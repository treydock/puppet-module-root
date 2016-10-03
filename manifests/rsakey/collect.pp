# Define: root::rsakey::collect
define root::rsakey::collect () {

  Root::Ssh_authorized_key <<| tag == $name |>>

}