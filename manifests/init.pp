# == Class: root
#
# Public class
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
    $_mailaliases = hiera_array('root::mailaliases', $mailaliases)
  } else {
    $_mailaliases = $mailaliases
  }
  validate_array($_mailaliases)

  $mailalias_ensure = empty($_mailaliases) ? {
    true  => 'absent',
    false => 'present',
  }

  if $ssh_authorized_keys_hiera_merge {
    $_ssh_authorized_keys = hiera_hash('root::ssh_authorized_keys', $ssh_authorized_keys)
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

  if is_array($_ssh_authorized_keys) and ! empty($_ssh_authorized_keys) {
    ensure_resource('root::ssh_authorized_key', $_ssh_authorized_keys)
  }

  if is_hash($_ssh_authorized_keys) and ! empty($_ssh_authorized_keys) {
    create_resources('root::ssh_authorized_key', $_ssh_authorized_keys)
  }

  if $export_key {
    include root::rsakey::export
    Class['root'] -> Class['root::rsakey::export']
  }

  if $collect_exported_keys {
    root::rsakey::collect { $collect_exported_keys_tags: }
  }

}
