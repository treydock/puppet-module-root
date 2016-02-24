require 'spec_helper'
require 'facter/root_sshrsakey'

describe 'root_sshrsakey fact' do
  before do
    Facter.clear
  end

  after do
    Facter.clear
  end
  
  before :each do
    Facter.fact(:kernel).stubs(:value).returns("Linux")
  end

  it "should return /root/.ssh/id_rsa.pub key" do
    FileTest.stubs(:file?).with('/root/.ssh/id_rsa.pub').returns(true)
    Facter::Util::FileRead.expects(:read).with('/root/.ssh/id_rsa.pub').returns("ssh-rsa SOMEKEY== root@foo\n")
    expect(Facter.fact(:root_sshrsakey).value).to eq('SOMEKEY==')
  end

  it "should return nothing if /root/.ssh/id_rsa.pub is not present" do
    FileTest.stubs(:file?).with('/root/.ssh/id_rsa.pub').returns(false)
    expect(Facter.fact(:root_sshrsakey).value).to be nil
  end
end
