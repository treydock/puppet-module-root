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

  if size($name_parts) < 3 and $key == 'UNSET' and $type == 'UNSET' {
    fail("Unsupported namevar: ${name}, module ${module_name} when key and type are not defined")
  }

  if size($name_parts) == 4 {
    $options_real = $options ? {
      'UNSET' => $name_parts[0],
      default => $options,
    }
    $type_real = $type ? {
      'UNSET' => $name_parts[1],
      default => $type,
    }
    $key_real = $key ? {
      'UNSET' => $name_parts[2],
      default => $key,
    }
    $name_real = $name_parts[3]
  } elsif size($name_parts) == 3 {
    $options_real = $options ? {
      'UNSET' => undef,
      default => $options,
    }
    $type_real = $type ? {
      'UNSET' => $name_parts[0],
      default => $type,
    }
    $key_real = $key ? {
      'UNSET' => $name_parts[1],
      default => $key,
    }
    $name_real = $name_parts[2]
  } else {
    $options_real = $options ? {
      'UNSET' => undef,
      default => $options,
    }
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
