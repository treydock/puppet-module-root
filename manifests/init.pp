# @summary Manage root user
#
# @example
#   include ::root
#
# @param mailaliases
#   An array that defines mailaliases for the root user (defaults to an empty array).
#   When an empty array is given Mailaliases[root] is set to `ensure => absent`.
#
# @param ssh_authorized_keys
#   Defines ssh_autorized_keys to be passed to the `root::ssh_authorized_key` defined type.
#   See `root::ssh_authorized_key` for examples of valid formats
#
# @param password
#   The password hash used for the root account.
#
# @param purge_ssh_keys
#   Sets if unmanaged SSH keys will be purged for the root account.
#
# @param generate_key_type
#   Type of SSH key to generate when exporting
#
# @param export_key
#   Sets if the root SSH RSA key should be created and exported.
#
# @param export_key_type
#   The ssh_authorized_key type that is exported
#
# @param export_key_options
#   Options to set for the exported SSH RSA key
#
# @param export_key_tag
#   The tag to use when exporting the root SSH RSA key.
#
# @param collect_exported_keys
#   Sets if the export root SSH RSA keys should be collected.
#
# @param collect_exported_keys_tags
#   Array of tags for root SSH RSA keys to collect.
#
# @param ssh_private_key
#   Path to root's SSH private key
#
# @param ssh_private_key_source
#   The source for root's SSH RSA private key
#
# @param ssh_public_key
#   Path to root's SSH public key
#
# @param ssh_public_key_source
#   The source for root's SSH RSA public key
#
# @param logout_timeout
#   Time (in seconds) before idle interactive terminals will logout
#
# @param manage_kerberos
#   Boolean that sets if Kerberos files should be managed
#
# @param kerberos_login_principals
#   The Kerberos principals to write to /root/.k5login
#
# @param kerberos_users_commands
#   The Kerberos user principals and commands to write to /root/.k5users
#
class root (
  Array $mailaliases                        = [],
  Variant[Array, Hash] $ssh_authorized_keys = {},
  Optional[Variant[String, Sensitive[String]]] $password = undef,
  Boolean $purge_ssh_keys                   = true,
  Root::SSHKeyTypes $generate_key_type = 'rsa',
  Boolean $export_key                       = false,
  Optional[Root::SSHKeyTypes] $export_key_type = $generate_key_type,
  Optional[Array] $export_key_options       = undef,
  String $export_key_tag                    = $facts['networking']['domain'],
  Boolean $collect_exported_keys            = false,
  Array $collect_exported_keys_tags         = [$facts['networking']['domain']],
  Stdlib::Absolutepath $ssh_private_key = '/root/.ssh/id_rsa',
  Optional[String] $ssh_private_key_source  = undef,
  Stdlib::Absolutepath $ssh_public_key = '/root/.ssh/id_rsa.pub',
  Optional[String] $ssh_public_key_source   = undef,
  Boolean $manage_kerberos                  = true,
  Array $kerberos_login_principals               = [],
  Hash[String[1], Variant[String, Array]] $kerberos_users_commands = {},
  Optional[Integer[0, default]] $logout_timeout                    = undef,
) inherits root::params {
  $mailalias_ensure = empty($mailaliases) ? {
    true  => 'absent',
    false => 'present',
  }

  exec { 'root newaliases':
    command     => 'newaliases',
    path        => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    refreshonly => true,
    onlyif      => 'which newaliases',
  }

  if $password != undef {
    # ensure password is a sensitive value
    # even if we were not passed one
    $_password = Sensitive($password.unwrap)
  } else {
    $_password = undef
  }

  user { 'root':
    ensure         => 'present',
    comment        => 'root',
    forcelocal     => true,
    gid            => '0',
    home           => '/root',
    password       => $_password,
    shell          => '/bin/bash',
    uid            => '0',
    purge_ssh_keys => $purge_ssh_keys,
  }

  file { '/root':
    ensure => 'directory',
    path   => '/root',
    owner  => 'root',
    group  => 'root',
    mode   => '0550',
  }
  file { '/root/.ssh':
    ensure => 'directory',
    path   => '/root/.ssh',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }
  file { '/root/.ssh/authorized_keys':
    ensure => 'file',
    path   => '/root/.ssh/authorized_keys',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }
  if $ssh_private_key_source {
    file { $ssh_private_key:
      ensure    => 'file',
      owner     => 'root',
      group     => 'root',
      mode      => '0600',
      source    => $ssh_private_key_source,
      show_diff => false,
    }
  }
  if $ssh_public_key_source {
    file { $ssh_public_key:
      ensure    => 'file',
      owner     => 'root',
      group     => 'root',
      mode      => '0600',
      source    => $ssh_public_key_source,
      show_diff => false,
    }
  }

  mailalias { 'root':
    ensure    => $mailalias_ensure,
    recipient => $mailaliases,
    notify    => Exec['root newaliases'],
  }

  if $logout_timeout {
    $timeout_ensure = 'file'
  } else {
    $timeout_ensure = 'absent'
  }

  file { '/etc/profile.d/root_logout_timeout.sh':
    ensure  => $timeout_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('root/root_logout_timeout.sh.erb'),
  }

  file { '/etc/profile.d/root_logout_timeout.csh':
    ensure  => $timeout_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('root/root_logout_timeout.csh.erb'),
  }

  if $ssh_authorized_keys =~ Array {
    $ssh_authorized_keys.each |$key| {
      root::ssh_authorized_key { $key: }
    }
  } else {
    $ssh_authorized_keys.each |$name, $data| {
      root::ssh_authorized_key { $name:
        * => $data,
      }
    }
  }

  if $export_key {
    include root::key::export
    Class['root'] -> Class['root::key::export']
  }

  if $collect_exported_keys {
    root::key::collect { $collect_exported_keys_tags: }
  }

  if $manage_kerberos {
    contain root::kerberos
  }
}
