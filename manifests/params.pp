class root::params {
  
  $authorized_keys = $::root_authorized_keys ? {
    undef   => [],
    default => $::root_authorized_keys
  }
  
}