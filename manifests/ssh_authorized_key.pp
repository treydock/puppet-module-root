# == Define: root::ssh_authorized_key
#
# Define root user's ssh_authorized_key resources
#
define root::ssh_authorized_key (
  $ensure = 'present',
  $key = 'UNSET',
  $options = 'UNSET',
  $type = 'UNSET',
) {

  $name_parts = split($name, ' ')

  if size($name_parts) != 3 and $key == 'UNSET' and $type == 'UNSET' {
    fail("Unsupported namevar: ${name}, module ${module_name} when key and type are not defined")
  }

  if size($name_parts) == 3 {
    $name_real = $name_parts[2]
  } else {
    $name_real = $name
  }

  if $key == 'UNSET' and size($name_parts) == 3 {
    $key_real = $name_parts[1]
  } else {
    $key_real = $key
  }

  $options_real = $options ? {
    'UNSET' => undef,
    default => $options,
  }

  if $type == 'UNSET' and size($name_parts) == 3 {
    $type_real = $name_parts[0]
  } else {
    $type_real = $type
  }

  ssh_authorized_key { $name_real:
    ensure  => $ensure,
    name    => $name_real,
    key     => $key_real,
    options => $options_real,
    type    => $type_real,
    user    => 'root',
  }

}
