# @summary Private class
# @api private
class root::rsakey::export {
  exec { "ssh-keygen root@${facts['networking']['fqdn']}":
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "ssh-keygen -q -t rsa -C root@${facts['networking']['fqdn']} -N '' -f /root/.ssh/id_rsa",
    creates => ['/root/.ssh/id_rsa', '/root/.ssh/id_rsa.pub'],
  }

  if $facts['root_sshrsakey'] {
    @@root::ssh_authorized_key { "root@${facts['networking']['fqdn']}":
      ensure  => 'present',
      key     => $facts['root_sshrsakey'],
      type    => 'ssh-rsa',
      options => $root::export_key_options,
      tag     => $root::export_key_tag,
    }
  }
}
