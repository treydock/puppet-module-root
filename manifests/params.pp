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

  case $::osfamily {
    'RedHat': {

    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
