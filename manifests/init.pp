# == Class: root
#
# Manage the root user.
#
# === Parameters
#
# [*mailaliases*]
#   Array.  Sets the alias mail addresses for the root user.
#   Default: []
#
# [*authorized_keys*]
#   Array. Authorized keys for the root account.
#   Overrides the top-scope variable 'root_authorized_keys'.
#
# === Variables
#
# [*root_authorized_keys*]
#   The list or array of authorized keys for the root account.
#
# === Examples
#
#  class { root:
#    mailaliases     => [ 'foo@bar.com', 'root@bar.com']
#    authorized_keys => [ 'foo', 'bar' ]
#  }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class root (
  $mailaliases      = [],
  $authorized_keys  = $root::params::authorized_keys
) inherits root::params {

  validate_array($mailaliases)

  if is_array($authorized_keys) {
    $authorized_keys_real = $authorized_keys
  } elsif is_string($authorized_keys) {
    $authorized_keys_real = split($authorized_keys, ',')
  } else {
    fail('Invalid value for authorized_keys.  Expect an Array or String')
  }

  $mailalias_ensure = empty($mailaliases) ? {
    true  => 'absent',
    false => 'present',
  }

  exec { 'root newaliases':
    command     => 'newaliases',
    path        => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    refreshonly => true,
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
    content => template('root/authorized_keys.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }

  mailalias { 'root':
    ensure    => $mailalias_ensure,
    recipient => $mailaliases,
    notify    => Exec['root newaliases'],
  }

}
