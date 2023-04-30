# @summary Private class
# @api private
class root::kerberos {
  if ! empty($root::kerberos_login_principals) {
    $k5login = ['# File managed by Puppet (root::manage_kerberos = true), DO NOT EDIT'] + $root::kerberos_login_principals + ['']
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

  if ! empty($root::kerberos_users_commands) {
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
