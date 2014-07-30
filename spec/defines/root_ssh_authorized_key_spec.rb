require 'spec_helper'

describe 'root::ssh_authorized_key' do
  let(:facts) {{ :kernel => 'Linux' }}
  let(:title) { 'foo' }
  let(:params) do
    {
      :key  => 'longhash',
      :type => 'rsa',
    }
  end

  it do
    should contain_ssh_authorized_key('foo').only_with({
      :ensure   => 'present',
      :name     => 'foo',
      :key      => 'longhash',
      :type     => 'rsa',
      :user     => 'root',
    })
  end

  context 'when options defined' do
    let(:title) { 'foo' }
    let(:params) do
      {
        :key      => 'longhash',
        :options  => ['no-port-forwarding','no-pty'],
        :type     => 'rsa',
      }
    end

    it do
      should contain_ssh_authorized_key('foo').only_with({
        :ensure   => 'present',
        :name     => 'foo',
        :key      => 'longhash',
        :options  => ['no-port-forwarding','no-pty'],
        :type     => 'rsa',
        :user     => 'root',
      })
    end
  end

  context 'when name is a key' do
    let(:title) { "ssh-rsa longhash foo@bar" }
    let(:params) {{}}

    it { should create_root__ssh_authorized_key('ssh-rsa longhash foo@bar') }

    it do
      should contain_ssh_authorized_key('ssh-rsa longhash foo@bar').only_with({
        :ensure   => 'present',
        :name     => 'foo@bar',
        :key      => 'longhash',
        :type     => 'ssh-rsa',
        :user     => 'root',
      })
    end
  end

  context 'when key and type are not defined' do
    let(:title) { 'foo' }
    let(:params) {{}}

    it "should raise error" do
      expect { should compile }.to raise_error(/Unsupported namevar/)
    end
  end

end
