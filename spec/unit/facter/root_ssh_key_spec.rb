# frozen_string_literal: true

require 'spec_helper'
require 'facter/root_ssh_key'

describe 'root_ssh_key fact' do
  before(:each) do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
  end

  after(:each) do
    Facter.clear
  end

  it 'returns public keys' do
    allow(File).to receive(:exist?).with('/root/.ssh/id_dsa.pub').and_return(false)
    allow(File).to receive(:exist?).with('/root/.ssh/id_rsa.pub').and_return(true)
    allow(File).to receive(:exist?).with('/root/.ssh/id_ecdsa.pub').and_return(true)
    allow(File).to receive(:exist?).with('/root/.ssh/id_ecdsa_sk.pub').and_return(false)
    allow(File).to receive(:exist?).with('/root/.ssh/id_ed25519.pub').and_return(false)
    allow(File).to receive(:exist?).with('/root/.ssh/id_ed25519_sk.pub').and_return(false)
    allow(Facter::Util::Resolution).to receive(:exec).with('cat /root/.ssh/id_rsa.pub').and_return("ssh-rsa SOMEKEY== root@foo\n")
    allow(Facter::Util::Resolution).to receive(:exec).with('cat /root/.ssh/id_ecdsa.pub').and_return("ecdsa-sha2-nistp256 FOOBAR== root@foo\n")
    expect(Facter.fact(:root_ssh_key).value).to eq(
      {
        'rsa' => 'SOMEKEY==',
        'ecdsa' => 'FOOBAR=='
      },
    )
  end

  it 'returns nothing if no keys present' do
    allow(File).to receive(:exist?).with('/root/.ssh/id_dsa.pub').and_return(false)
    allow(File).to receive(:exist?).with('/root/.ssh/id_rsa.pub').and_return(false)
    allow(File).to receive(:exist?).with('/root/.ssh/id_ecdsa.pub').and_return(false)
    allow(File).to receive(:exist?).with('/root/.ssh/id_ecdsa_sk.pub').and_return(false)
    allow(File).to receive(:exist?).with('/root/.ssh/id_ed25519.pub').and_return(false)
    allow(File).to receive(:exist?).with('/root/.ssh/id_ed25519_sk.pub').and_return(false)
    expect(Facter.fact(:root_ssh_key).value).to eq({})
  end
end
