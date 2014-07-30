# == Class: root::params
#
# The root default configuration settings.
#
class root::params {

  case $::kernel {
    'Linux': {
      $ssh_authorized_keys  = hiera_hash('root_ssh_authorized_keys', {})
      $mailaliases          = hiera_array('root_mailaliases', [])
    }

    default: {
      fail("Unsupported kernel: ${::kernel}, module ${module_name} only support kernel Linux")
    }
  }

}
