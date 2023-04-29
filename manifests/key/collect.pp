# @summary Private class
# @api private
define root::key::collect () {
  Root::Ssh_authorized_key <<| tag == $name |>>
}
