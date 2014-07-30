require 'spec_helper'

describe 'root' do
  let(:facts) {{
    :kernel         => 'Linux',
    :serverversion  => Puppet.version,
    :clientversion  => Puppet.version,
  }}

  it { should create_class('root') }
  it { should contain_class('root::params') }

  it { should have_root__ssh_authorized_key_resource_count(0) }

  it do
    should contain_exec('root newaliases').only_with({
      :command      => 'newaliases',
      :path         => ['/usr/bin','/usr/sbin','/bin','/sbin'],
      :refreshonly  => 'true',
    })
  end

  if Gem::Version.new(Puppet.version) >= Gem::Version.new('3.6.0')
    it do
      should contain_user('root').only_with({
        :ensure         => 'present',
        :comment        => 'root',
        :forcelocal     => 'true',
        :gid            => '0',
        :home           => '/root',
        :password       => nil,
        :purge_ssh_keys => 'true',
        :shell          => '/bin/bash',
        :uid            => '0',
      })
    end
  else
    it do
      should contain_user('root').only_with({
        :ensure         => 'present',
        :comment        => 'root',
        :forcelocal     => 'true',
        :gid            => '0',
        :home           => '/root',
        :password       => nil,
        :shell          => '/bin/bash',
        :uid            => '0',
      })
    end
  end



  context 'when purge_ssh_keys => false' do
    let(:params) {{ :purge_ssh_keys => false }}
    if Gem::Version.new(Puppet.version) >= Gem::Version.new('3.6.0')
      it { should contain_user('root').with_purge_ssh_keys('false') }
    end
  end

  it { should contain_file('/root').that_comes_before('File[/root/.ssh]') }
  it { should contain_file('/root/.ssh').that_comes_before('File[/root/.ssh/authorized_keys]') }

  it do
    should contain_file('/root').only_with({
      :ensure   => 'directory',
      :path     => '/root',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0550',
      :before   => 'File[/root/.ssh]',
    })
  end

  it do
    should contain_file('/root/.ssh').only_with({
      :ensure   => 'directory',
      :path     => '/root/.ssh',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0700',
      :before   => 'File[/root/.ssh/authorized_keys]',
    })
  end

  it do
    should contain_file('/root/.ssh/authorized_keys').only_with({
      :ensure   => 'present',
      :path     => '/root/.ssh/authorized_keys',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0600',
    })
  end

  it { should contain_mailalias('root').with_ensure('absent') }

  context "authorized_keys as an Array" do
    let(:params) {{ :ssh_authorized_keys => [ 'ssh-rsa longhashfoo== foo', 'ssh-dss longhashbar== bar' ] }}

    it { should have_root__ssh_authorized_key_resource_count(2) }
    it { should contain_root__ssh_authorized_key('ssh-rsa longhashfoo== foo') }
    it { should contain_root__ssh_authorized_key('ssh-dss longhashbar== bar') }
    it do
      should contain_ssh_authorized_key('ssh-rsa longhashfoo== foo').with({
        :name => 'foo',
        :key  => 'longhashfoo==',
        :type => 'ssh-rsa',
      })
    end
    it do
      should contain_ssh_authorized_key('ssh-dss longhashbar== bar').with({
        :name => 'bar',
        :key  => 'longhashbar==',
        :type => 'ssh-dss',
      })
    end
  end

  context "authorized_keys as a Hash" do
    let(:params) {{ :ssh_authorized_keys => {
      'foo' => {
        'key'   => 'longhashfoo==',
        'type'  => 'rsa',
      },
      'bar' => {
        'key'   => 'longhashbar==',
        'type'  => 'dss',
      }
    }}}

    it { should have_root__ssh_authorized_key_resource_count(2) }
    it do
      should contain_root__ssh_authorized_key('foo').with({
        :key  => 'longhashfoo==',
        :type => 'rsa',
      })
    end
    it do
      should contain_root__ssh_authorized_key('bar').with({
        :key  => 'longhashbar==',
        :type => 'dss',
      })
    end
    it do
      should contain_ssh_authorized_key('foo').with({
        :key  => 'longhashfoo==',
        :type => 'rsa',
      })
    end
    it do
      should contain_ssh_authorized_key('bar').with({
        :key  => 'longhashbar==',
        :type => 'dss',
      })
    end
  end

  context "mailaliases => ['foo', 'bar']" do
    let(:params) {{ :mailaliases => ['foo','bar'] }}

    it do
      should contain_mailalias('root').with({
        :ensure     => 'present',
        :recipient  => ['foo','bar'],
        :notify     => 'Exec[root newaliases]',
      })
    end
  end

  context "mailaliases => 'foo'" do
    let(:params) {{ :mailaliases => 'foo' }}
    it { expect { should compile }.to raise_error(/is not an Array/) }
  end

  context "purge_ssh_keys => 'foo'" do
    let(:params) {{ :purge_ssh_keys => 'foo' }}
    it { expect { should compile }.to raise_error(/is not a boolean/) }
  end
end
