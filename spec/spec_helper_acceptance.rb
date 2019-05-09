require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/acceptance/shared_examples/**/*.rb"].sort.each { |f| require f }
require 'spec_helper_acceptance_local' if File.file?(File.join(File.dirname(__FILE__), 'spec_helper_acceptance_local.rb'))

run_puppet_install_helper
install_module_on(hosts)
install_module_dependencies_on(hosts)
collection = ENV['BEAKER_PUPPET_COLLECTION'] || 'puppet5'
if collection == 'puppet6'
  on hosts, puppet('module', 'install', 'puppetlabs-mailalias_core')
  on hosts, puppet('module', 'install', 'puppetlabs-sshkeys_core')
end

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation
end

# 'spec_overrides' from sync.yml will appear below this line
