# == Class: root
#
# Public class
#
class root (
  $mailaliases          = $root::params::mailaliases,
  $ssh_authorized_keys  = $root::params::authorized_keys,
  $password             = undef,
  $purge_ssh_keys       = true,
) inherits root::params {

  validate_array($mailaliases)
  validate_bool($purge_ssh_keys)

  $mailalias_ensure = empty($mailaliases) ? {
    true  => 'absent',
    false => 'present',
  }

  exec { 'root newaliases':
    command     => 'newaliases',
    path        => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    refreshonly => true,
  }

  user { 'root':
    ensure          => 'present',
    comment         => 'root',
    forcelocal      => true,
    gid             => '0',
    home            => '/root',
    password        => $password,
    shell           => '/bin/bash',
    uid             => '0',
  }

  if versioncmp($serverversion, '3.6.0') >= 0 and versioncmp($clientversion, '3.6.0') >= 0 {
    User <| title == 'root' |> {
      purge_ssh_keys  => $purge_ssh_keys,
    }
  }

  file { '/root':
    ensure  => 'directory',
    path    => '/root',
    owner   => 'root',
    group   => 'root',
    mode    => '0550',
  }->
  file { '/root/.ssh':
    ensure  => 'directory',
    path    => '/root/.ssh',
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
  }->
  file { '/root/.ssh/authorized_keys':
    ensure  => 'present',
    path    => '/root/.ssh/authorized_keys',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }

  mailalias { 'root':
    ensure    => $mailalias_ensure,
    recipient => $mailaliases,
    notify    => Exec['root newaliases'],
  }

  if is_array($ssh_authorized_keys) and ! empty($ssh_authorized_keys) {
    ensure_resource('root::ssh_authorized_key', $ssh_authorized_keys)
  }

  if is_hash($ssh_authorized_keys) and ! empty($ssh_authorized_keys) {
    create_resources('root::ssh_authorized_key', $ssh_authorized_keys)
  }

}
