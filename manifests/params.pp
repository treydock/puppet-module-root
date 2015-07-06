# == Class: root::params
#
# The root default configuration settings.
#
class root::params {

  case $::kernel {
    'Linux': {
      # Do nothing
    }

    default: {
      fail("Unsupported kernel: ${::kernel}, module ${module_name} only support kernel Linux")
    }
  }

}
