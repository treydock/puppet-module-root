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
# @param export_key_tag
#   The tag to use when exporting the root SSH RSA key.
#
# @param collect_exported_keys
#   Sets if the export root SSH RSA keys should be collected.
#
# @param collect_exported_keys_tags
#   Array of tags for root SSH RSA keys to collect.
#
class root (
  Array $mailaliases                        = [],
  Boolean $mailaliases_hiera_merge          = true,
  Variant[Array, Hash] $ssh_authorized_keys = {},
  Boolean $ssh_authorized_keys_hiera_merge  = true,
  Optional[String] $password                = undef,
  Boolean $purge_ssh_keys                   = true,
  Boolean $export_key                       = false,
  String $export_key_tag                    = $::domain,
  Boolean $collect_exported_keys            = false,
  Array $collect_exported_keys_tags         = [$::domain],
  Optional[String] $ssh_private_key_source  = undef,
  Optional[String] $ssh_public_key_source   = undef,
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

  user { 'root':
    ensure         => 'present',
    comment        => 'root',
    forcelocal     => true,
    gid            => '0',
    home           => '/root',
    password       => $password,
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
      ensure => 'present',
      path   => '/root/.ssh/id_rsa',
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
      source => $ssh_private_key_source,
    }
  }
  if $ssh_public_key_source {
    file { '/root/.ssh/id_rsa.pub':
      ensure => 'present',
      path   => '/root/.ssh/id_rsa.pub',
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
      source => $ssh_public_key_source,
    }
  }

  mailalias { 'root':
    ensure    => $mailalias_ensure,
    recipient => $_mailaliases,
    notify    => Exec['root newaliases'],
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
    contain root::rsakey::export
    Class['root'] -> Class['root::rsakey::export']
  }

  if $collect_exported_keys {
    root::rsakey::collect { $collect_exported_keys_tags: }
  }

}
