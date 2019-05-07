require 'spec_helper'
require 'facter/root_sshrsakey'

describe 'root_sshrsakey fact' do
  before(:each) do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
  end

  after(:each) do
    Facter.clear
  end

  it 'returns /root/.ssh/id_rsa.pub key' do
    allow(FileTest).to receive(:file?).with('/root/.ssh/id_rsa.pub').and_return(true)
    allow(Facter::Util::Resolution).to receive(:exec).with('cat /root/.ssh/id_rsa.pub').and_return("ssh-rsa SOMEKEY== root@foo\n")
    expect(Facter.fact(:root_sshrsakey).value).to eq('SOMEKEY==')
  end

  it 'returns nothing if /root/.ssh/id_rsa.pub is not present' do
    allow(FileTest).to receive(:file?).with('/root/.ssh/id_rsa.pub').and_return(false)
    expect(Facter.fact(:root_sshrsakey).value).to be nil
  end
end
