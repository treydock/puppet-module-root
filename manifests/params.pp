# == Class: root::params
#
# Default parameters for the root class.
# This class looks for variables in top scope (such as ENC).
# The parameterized value takes presedence over the variables.
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class root::params {

  $authorized_keys = $::root_authorized_keys ? {
    undef   => [],
    default => $::root_authorized_keys
  }

  case $::kernel {
    'Linux': {
      # Do nothing
    }

    default: {
      fail("Unsupported kernel: ${::kernel}, module ${module_name} only support kernel Linux")
    }
  }

}
