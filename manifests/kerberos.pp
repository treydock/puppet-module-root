# @summary Private class
# @api private
class root::kerberos {
  $kerberos_login_principals_hiera_merge = $root::kerberos_login_principals_hiera_merge
  $kerberos_login_principals = $root::kerberos_login_principals
  $kerberos_users_commands_hiera_merge = $root::kerberos_users_commands_hiera_merge
  $kerberos_users_commands = $root::kerberos_users_commands

  if $kerberos_login_principals_hiera_merge {
    $_kerberos_login_principals = lookup('root::kerberos_login_principals', Array, 'unique', $kerberos_login_principals)
  } else {
    $_kerberos_login_principals = $kerberos_login_principals
  }

  if $kerberos_users_commands_hiera_merge {
    $_kerberos_users_commands = lookup('root::kerberos_users_commands', Hash, { 'strategy' => 'deep', 'merge_hash_arrays' => true }, $kerberos_users_commands)
  } else {
    $_kerberos_users_commands = $kerberos_users_commands
  }

  if ! empty($_kerberos_login_principals) {
    $k5login = ['# File managed by Puppet (root::manage_kerberos = true), DO NOT EDIT'] + $_kerberos_login_principals + ['']
    file { '/root/.k5login':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => join($k5login, "\n"),
    }
  } else {
    file { '/root/.k5login': ensure => 'absent' }
  }

  if ! empty($_kerberos_users_commands) {
    file { '/root/.k5users':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => template('root/k5users.erb'),
    }
  } else {
    file { '/root/.k5users': ensure => 'absent' }
  }
}
