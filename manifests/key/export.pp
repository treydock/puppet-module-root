# @summary Private class
# @api private
class root::key::export {
  $key_path_type = regsubst($root::generate_key_type, '-', '_', 'G')
  $key_path = "/root/.ssh/id_${key_path_type}"
  exec { "ssh-keygen root@${facts['networking']['fqdn']}":
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "ssh-keygen -q -t ${root::generate_key_type} -C root@${facts['networking']['fqdn']} -N '' -f ${key_path}",
    creates => [$key_path, "${key_path}.pub"],
  }

  if $root::export_key_type == 'ecdsa' {
    $export_key_type = 'ecdsa-sha2-nistp256'
  } else {
    $export_key_type = $root::export_key_type
  }
  $root_export_key = $facts.dig('root_ssh_key', $root::export_key_type)

  if $root_export_key {
    @@root::ssh_authorized_key { "root@${facts['networking']['fqdn']}":
      ensure  => 'present',
      key     => $root_export_key,
      type    => $export_key_type,
      options => $root::export_key_options,
      tag     => $root::export_key_tag,
    }
  }
}
