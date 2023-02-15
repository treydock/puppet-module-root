# @summary Private class
# @api private
class root::params {
  case $facts['kernel'] {
    'Linux': {
      # Do nothing
    }

    default: {
      fail("Unsupported kernel: ${facts['kernel']}, module ${module_name} only support kernel Linux")
    }
  }
}
