require 'spec_helper'

describe 'root' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(puppetversion: Puppet.version)
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to create_class('root') }
      it { is_expected.to contain_class('root::params') }

      it { is_expected.to have_root__ssh_authorized_key_resource_count(0) }

      it do
        is_expected.to contain_exec('root newaliases').only_with(command: 'newaliases',
                                                                 path: ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
                                                                 refreshonly: 'true',
                                                                 onlyif: 'which newaliases')
      end

      it do
        is_expected.to contain_user('root').only_with(ensure: 'present',
                                                      comment: 'root',
                                                      forcelocal: 'true',
                                                      gid: '0',
                                                      home: '/root',
                                                      shell: '/bin/bash',
                                                      uid: '0',
                                                      purge_ssh_keys: 'true')
      end

      it { is_expected.not_to contain_class('root::rsakey::export') }
      it { is_expected.to have_root__rsakey__collect_resource_count(0) }

      context 'when purge_ssh_keys => false' do
        let(:params) { { purge_ssh_keys: false } }

        it { is_expected.to contain_user('root').with_purge_ssh_keys('false') }
      end

      it { is_expected.to contain_file('/root').that_comes_before('File[/root/.ssh]') }
      it { is_expected.to contain_file('/root/.ssh').that_comes_before('File[/root/.ssh/authorized_keys]') }

      it do
        is_expected.to contain_file('/root').only_with(ensure: 'directory',
                                                       path: '/root',
                                                       owner: 'root',
                                                       group: 'root',
                                                       mode: '0550')
      end

      it do
        is_expected.to contain_file('/root/.ssh').only_with(ensure: 'directory',
                                                            path: '/root/.ssh',
                                                            owner: 'root',
                                                            group: 'root',
                                                            mode: '0700')
      end

      it do
        is_expected.to contain_file('/root/.ssh/authorized_keys').only_with(ensure: 'present',
                                                                            path: '/root/.ssh/authorized_keys',
                                                                            owner: 'root',
                                                                            group: 'root',
                                                                            mode: '0600')
      end

      it { is_expected.to contain_mailalias('root').with_ensure('absent') }

      context 'authorized_keys as an Array' do
        let(:params) { { ssh_authorized_keys: ['ssh-rsa longhashfoo== foo', 'ssh-dss longhashbar== bar'] } }

        it { is_expected.to have_root__ssh_authorized_key_resource_count(2) }
        it { is_expected.to contain_root__ssh_authorized_key('ssh-rsa longhashfoo== foo') }
        it { is_expected.to contain_root__ssh_authorized_key('ssh-dss longhashbar== bar') }
        it do
          is_expected.to contain_ssh_authorized_key('ssh-rsa longhashfoo== foo').with(name: 'foo',
                                                                                      key: 'longhashfoo==',
                                                                                      type: 'ssh-rsa')
        end
        it do
          is_expected.to contain_ssh_authorized_key('ssh-dss longhashbar== bar').with(name: 'bar',
                                                                                      key: 'longhashbar==',
                                                                                      type: 'ssh-dss')
        end
      end

      context 'authorized_keys as a Hash' do
        let(:params) do
          { ssh_authorized_keys: {
            'foo' => {
              'key'   => 'longhashfoo==',
              'type'  => 'rsa',
            },
            'bar' => {
              'key'   => 'longhashbar==',
              'type' => 'dss',
            },
          } }
        end

        it { is_expected.to have_root__ssh_authorized_key_resource_count(2) }
        it do
          is_expected.to contain_root__ssh_authorized_key('foo').with(key: 'longhashfoo==',
                                                                      type: 'rsa')
        end
        it do
          is_expected.to contain_root__ssh_authorized_key('bar').with(key: 'longhashbar==',
                                                                      type: 'dss')
        end
        it do
          is_expected.to contain_ssh_authorized_key('foo').with(key: 'longhashfoo==',
                                                                type: 'rsa')
        end
        it do
          is_expected.to contain_ssh_authorized_key('bar').with(key: 'longhashbar==',
                                                                type: 'dss')
        end
      end

      context "mailaliases => ['foo', 'bar']" do
        let(:params) { { mailaliases: ['foo', 'bar'] } }

        it do
          is_expected.to contain_mailalias('root').with(ensure: 'present',
                                                        recipient: ['foo', 'bar'],
                                                        notify: 'Exec[root newaliases]')
        end
      end

      context 'export_key => true' do
        let(:params) { { export_key: true } }
        let(:facts) do
          facts.merge(root_sshrsakey: 'somelonghash==')
        end

        it { is_expected.to contain_class('root::rsakey::export') }

        it do
          is_expected.to contain_exec("ssh-keygen root@#{facts[:fqdn]}").with(path: '/usr/bin:/bin:/usr/sbin:/sbin',
                                                                              command: "ssh-keygen -q -t rsa -C root@#{facts[:fqdn]} -N '' -f /root/.ssh/id_rsa",
                                                                              creates: ['/root/.ssh/id_rsa', '/root/.ssh/id_rsa.pub'])
        end
      end

      context 'collect_exported_keys => true' do
        let(:params) { { collect_exported_keys: true } }

        it { is_expected.to have_root__rsakey__collect_resource_count(1) }
        it { is_expected.to contain_root__rsakey__collect(facts[:domain]) }

        context 'when multiple export_key_tags defined' do
          let(:params) { { collect_exported_keys: true, collect_exported_keys_tags: ['foo', 'bar'] } }

          it { is_expected.to have_root__rsakey__collect_resource_count(2) }
          it { is_expected.to contain_root__rsakey__collect('foo') }
          it { is_expected.to contain_root__rsakey__collect('bar') }
        end
      end
    end # end context
  end # end on_supported_os
end # end describe
