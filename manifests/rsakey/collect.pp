# Define: root::rsakey::collect
define root::rsakey::collect () {

  Ssh_authorized_key <<| tag == $name |>>

}