# == Class: root
#
# Manage the root directory and SSH authorized_keys.
#
# === Parameters
#
# [*authorized_keys*]
#   The array of authorized keys for the root account.
#   Overrides the variable 'root_authorized_keys'.
#
# === Variables
#
# [*root_authorized_keys*]
#   The list or array of authorized keys for the root account.
#
# === Examples
#
#  class { root:
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
  $authorized_keys = $root::params::authorized_keys

) inherits root::params {

  if is_array($authorized_keys) {
    $authorized_keys_real = $authorized_keys
  } elsif is_string($authorized_keys) {
    $authorized_keys_real = split($authorized_keys, ',')
  } else {
    fail('Invalid value for authorized_keys.  Expect an Array or String')
  }

  $authorized_keys_length = inline_template('<%= @authorized_keys_real.size %>')

  if $authorized_keys_length == 0 {
    $authorized_keys_content = undef
  } else {
    $authorized_keys_content = template('root/authorized_keys.erb')
  }

  file { '/root':
    ensure  => 'directory',
    path    => '/root',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
  }

  file { '/root/.ssh':
    ensure  => 'directory',
    path    => '/root/.ssh',
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    require => File['/root'],
  }

  
  file { '/root/.ssh/authorized_keys':
    ensure  => 'present',
    path    => '/root/.ssh/authorized_keys',
    content => $authorized_keys_content,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => File['/root/.ssh'],
  }

}
