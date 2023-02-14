# @summary Manage root user
#
# @example
#   include ::root
#
# @param mailaliases
#   An array that defines mailaliases for the root user (defaults to an empty array).
#   When an empty array is given Mailaliases[root] is set to `ensure => absent`.
#
# @param mailaliases_hiera_merge
#   Boolean that determines if the Hiera lookup merging is used for `root::mailaliases` values.
#
# @param ssh_authorized_keys
#   Defines ssh_autorized_keys to be passed to the `root::ssh_authorized_key` defined type.
#   See `root::ssh_authorized_key` for examples of valid formats
#
# @param ssh_authorized_keys_hiera_merge
#   Boolean that determines if the Hiera lookup merging `root::ssh_authorized_keys` values.
#
# @param password
#   The password hash used for the root account.
#
# @param purge_ssh_keys
#   Sets if unmanaged SSH keys will be purged for the root account.
#
# @param export_key
#   Sets if the root SSH RSA key should be created and exported.
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
# @param ssh_private_key_source
#   The source for root's SSH RSA private key
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
# @param kerberos_login_principals_hiera_merge
#   Boolean that determines if the Hiera lookup merging `root::kerberos_login_principals` values.
#
# @param kerberos_login_principals
#   The Kerberos principals to write to /root/.k5login
#
# @param kerberos_users_commands_hiera_merge
#   Boolean that determines if the Hiera lookup merging `root::kerberos_users_commands` values.
#
# @param kerberos_users_commands
#   The Kerberos user principals and commands to write to /root/.k5users
#
class root (
  Array $mailaliases                        = [],
  Boolean $mailaliases_hiera_merge          = true,
  Variant[Array, Hash] $ssh_authorized_keys = {},
  Boolean $ssh_authorized_keys_hiera_merge  = true,
  Optional[Variant[String, Sensitive[String]]] $password = undef,
  Boolean $purge_ssh_keys                   = true,
  Boolean $export_key                       = false,
  Optional[Array] $export_key_options       = undef,
  String $export_key_tag                    = $facts['networking']['domain'],
  Boolean $collect_exported_keys            = false,
  Array $collect_exported_keys_tags         = [$facts['networking']['domain']],
  Optional[String] $ssh_private_key_source  = undef,
  Optional[String] $ssh_public_key_source   = undef,
  Boolean $manage_kerberos                  = true,
  Boolean $kerberos_login_principals_hiera_merge = true,
  Array $kerberos_login_principals               = [],
  Boolean $kerberos_users_commands_hiera_merge   = true,
  Hash[String[1], Variant[String, Array]] $kerberos_users_commands = {},
  Optional[Integer[0, default]] $logout_timeout                    = undef,
) inherits root::params {

  if $mailaliases_hiera_merge {
    $_mailaliases = lookup('root::mailaliases', Array, 'unique', $mailaliases)
  } else {
    $_mailaliases = $mailaliases
  }

  $mailalias_ensure = empty($_mailaliases) ? {
    true  => 'absent',
    false => 'present',
  }

  if $ssh_authorized_keys_hiera_merge {
    if $ssh_authorized_keys =~ Array {
      $_ssh_authorized_keys = lookup('root::ssh_authorized_keys', Array, 'unique', $ssh_authorized_keys)
    } else {
      $_ssh_authorized_keys = lookup('root::ssh_authorized_keys', Hash, 'deep', $ssh_authorized_keys)
    }
  } else {
    $_ssh_authorized_keys = $ssh_authorized_keys
  }

  exec { 'root newaliases':
    command     => 'newaliases',
    path        => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    refreshonly => true,
    onlyif      => 'which newaliases'
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
    ensure => 'present',
    path   => '/root/.ssh/authorized_keys',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }
  if $ssh_private_key_source {
    file { '/root/.ssh/id_rsa':
      ensure    => 'present',
      path      => '/root/.ssh/id_rsa',
      owner     => 'root',
      group     => 'root',
      mode      => '0600',
      source    => $ssh_private_key_source,
      show_diff => false,
    }
  }
  if $ssh_public_key_source {
    file { '/root/.ssh/id_rsa.pub':
      ensure    => 'present',
      path      => '/root/.ssh/id_rsa.pub',
      owner     => 'root',
      group     => 'root',
      mode      => '0600',
      source    => $ssh_public_key_source,
      show_diff => false,
    }
  }

  mailalias { 'root':
    ensure    => $mailalias_ensure,
    recipient => $_mailaliases,
    notify    => Exec['root newaliases'],
  }

  if $logout_timeout {
    $timeout_ensure = 'file'
  } else {
    $timeout_ensure = 'absent'
  }

  file {'/etc/profile.d/root_logout_timeout.sh':
    ensure  => $timeout_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content =>  template('root/root_logout_timeout.sh.erb')
  }

  file {'/etc/profile.d/root_logout_timeout.csh':
    ensure  => $timeout_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content =>  template('root/root_logout_timeout.csh.erb')
  }

  if $_ssh_authorized_keys =~ Array {
    $_ssh_authorized_keys.each |$key| {
      root::ssh_authorized_key { $key: }
    }
  } else {
    $_ssh_authorized_keys.each |$name, $data| {
      root::ssh_authorized_key { $name:
        * => $data,
      }
    }
  }

  if $export_key {
    include root::rsakey::export
    Class['root'] -> Class['root::rsakey::export']
  }

  if $collect_exported_keys {
    root::rsakey::collect { $collect_exported_keys_tags: }
  }

  if $manage_kerberos {
    contain root::kerberos
  }
}
