# == Class: root
#
# Public class
#
class root (
  $mailaliases                      = [],
  $mailaliases_hiera_merge          = true,
  $ssh_authorized_keys              = {},
  $ssh_authorized_keys_hiera_merge  = true,
  $password                         = undef,
  $purge_ssh_keys                   = true,
) inherits root::params {

  validate_bool($mailaliases_hiera_merge, $ssh_authorized_keys_hiera_merge, $purge_ssh_keys)

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
  }

  user { 'root':
    ensure     => 'present',
    comment    => 'root',
    forcelocal => true,
    gid        => '0',
    home       => '/root',
    password   => $password,
    shell      => '/bin/bash',
    uid        => '0',
  }

  if versioncmp($::puppetversion, '3.6.0') >= 0 {
    User <| title == 'root' |> {
      purge_ssh_keys => $purge_ssh_keys,
    }
  }

  file { '/root':
    ensure => 'directory',
    path   => '/root',
    owner  => 'root',
    group  => 'root',
    mode   => '0550',
  }->
  file { '/root/.ssh':
    ensure => 'directory',
    path   => '/root/.ssh',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }->
  file { '/root/.ssh/authorized_keys':
    ensure => 'present',
    path   => '/root/.ssh/authorized_keys',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
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

}
