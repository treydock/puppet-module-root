# @summary Private class
# @api private
class root::rsakey::export {

  exec { "ssh-keygen root@${::fqdn}":
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "ssh-keygen -q -t rsa -C root@${::fqdn} -N '' -f /root/.ssh/id_rsa",
    creates => ['/root/.ssh/id_rsa', '/root/.ssh/id_rsa.pub'],
  }

  if $::root_sshrsakey {
    @@root::ssh_authorized_key { "root@${::fqdn}":
      ensure  => 'present',
      key     => $::root_sshrsakey,
      type    => 'ssh-rsa',
      options => $::root::export_key_options,
      tag     => $root::export_key_tag,
    }
  }

}
