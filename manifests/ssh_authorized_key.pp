# @summary Define root user's ssh_authorized_key resources
#
# @example Define ssh_authorized_key using Hash
#   root::ssh_authorized_key { 'user@fqdn':
#     type => 'ssh-rsa',
#     key  => 'somelonghash==',
#   }
#
# @example Define ssh_authorized_key using name string
#   root::ssh_authorized_key { 'ssh-rsa somelonghash== user@fqdn': }
#
# @param ensure
#   ssh_authorized_key ensure property
#
# @param key
#   The SSH key hash
#
# @param options
#   The SSH key options
#
# @param type
#   The type of SSH key.
#
define root::ssh_authorized_key (
  Enum['present','absent'] $ensure = 'present',
  Optional[String[1]] $key = undef,
  Optional[Variant[String[1], Array]] $options = undef,
  Optional[String[1]] $type = undef,
) {
  $name_parts = split($name, ' ')

  if size($name_parts) < 3 and $key =~ Undef and $type =~ Undef {
    fail("Unsupported namevar: ${name}, module ${module_name} when key and type are not defined")
  }

  if size($name_parts) == 4 {
    $options_real = pick($options, $name_parts[0])
    $type_real = pick($type, $name_parts[1])
    $key_real = pick($key, $name_parts[2])
    $name_real = $name_parts[3]
  } elsif size($name_parts) == 3 {
    $options_real = $options
    $type_real = pick($type, $name_parts[0])
    $key_real = pick($key, $name_parts[1])
    $name_real = $name_parts[2]
  } else {
    $options_real = $options
    $type_real = $type
    $key_real = $key
    $name_real = $name
  }

  ssh_authorized_key { $name:
    ensure  => $ensure,
    name    => $name_real,
    key     => $key_real,
    options => $options_real,
    type    => $type_real,
    user    => 'root',
  }
}
