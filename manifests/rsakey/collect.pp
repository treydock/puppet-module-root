# @summary Private class
# @api private
define root::rsakey::collect () {

  Root::Ssh_authorized_key <<| tag == $name |>>

}