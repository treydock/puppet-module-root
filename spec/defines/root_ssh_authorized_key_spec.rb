require 'spec_helper'

describe 'root::ssh_authorized_key' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(puppetversion: Puppet.version)
      end

      let(:title) { 'foo' }
      let(:params) do
        {
          key: 'longhash',
          type: 'rsa',
        }
      end

      it do
        is_expected.to contain_ssh_authorized_key('foo').only_with(ensure: 'present',
                                                                   name: 'foo',
                                                                   key: 'longhash',
                                                                   type: 'rsa',
                                                                   user: 'root')
      end

      context 'when options defined' do
        let(:title) { 'foo' }
        let(:params) do
          {
            key: 'longhash',
            options: ['no-port-forwarding', 'no-pty'],
            type: 'rsa',
          }
        end

        it do
          is_expected.to contain_ssh_authorized_key('foo').only_with(ensure: 'present',
                                                                     name: 'foo',
                                                                     key: 'longhash',
                                                                     options: ['no-port-forwarding', 'no-pty'],
                                                                     type: 'rsa',
                                                                     user: 'root')
        end
      end

      context 'when name is a key' do
        let(:title) { 'ssh-rsa longhash foo@bar' }
        let(:params) { {} }

        it { is_expected.to create_root__ssh_authorized_key('ssh-rsa longhash foo@bar') }

        it do
          is_expected.to contain_ssh_authorized_key('ssh-rsa longhash foo@bar').only_with(ensure: 'present',
                                                                                          name: 'foo@bar',
                                                                                          key: 'longhash',
                                                                                          type: 'ssh-rsa',
                                                                                          user: 'root')
        end
      end

      context 'when key and type are not defined' do
        let(:title) { 'foo' }
        let(:params) { {} }

        it 'raises error' do
          expect { is_expected.to compile }.to raise_error(%r{Unsupported namevar})
        end
      end
    end # end context
  end # end on_supported_os
end # end describe
