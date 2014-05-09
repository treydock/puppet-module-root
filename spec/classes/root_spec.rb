require 'spec_helper'

describe 'root' do
  let :default_facts do
    {
      :kernel                 => 'Linux',
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.4',
      :architecture           => 'x86_64',
    }
  end

  let(:facts) { default_facts }

  it { should create_class('root') }
  it { should contain_class('root::params') }

  it do
    should contain_exec('root newaliases').only_with({
      'command'     => 'newaliases',
      'path'        => ['/usr/bin','/usr/sbin','/bin','/sbin'],
      'refreshonly' => 'true',
    })
  end

  it { should contain_file('/root').that_comes_before('File[/root/.ssh]') }
  it { should contain_file('/root/.ssh').that_comes_before('File[/root/.ssh/authorized_keys]') }

  it do
    should contain_file('/root').only_with({
      'ensure'  => 'directory',
      'path'    => '/root',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0550',
      'before'  => 'File[/root/.ssh]',
    })
  end

  it do
    should contain_file('/root/.ssh').only_with({
      'ensure'  => 'directory',
      'path'    => '/root/.ssh',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0700',
      'before'  => 'File[/root/.ssh/authorized_keys]',
    })
  end

  it do
    should contain_file('/root/.ssh/authorized_keys').only_with({
      'ensure'  => 'present',
      'path'    => '/root/.ssh/authorized_keys',
      'content' => '',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0600',
    })
  end

  it { should contain_mailalias('root').with_ensure('absent') }

  context "authorized_keys as array" do
    let(:params) {{ :authorized_keys => [ 'foo', 'bar' ] }}

    it do
      verify_contents(catalogue, '/root/.ssh/authorized_keys', ['foo','bar'])
    end
  end

  context "authorized_keys as list" do
    let(:params) {{ :authorized_keys => 'foo,bar' }}

    it do
      verify_contents(catalogue, '/root/.ssh/authorized_keys', ['foo','bar'])
    end
  end

  context "authorized_keys as top-scope variable root_authorized_keys" do
    let(:facts) { default_facts.merge({ :root_authorized_keys => 'foo,bar' }) }
    let(:params) {{}}

    it do
      verify_contents(catalogue, '/root/.ssh/authorized_keys', ['foo','bar'])
    end
  end

  context "mailaliases => ['foo', 'bar']" do
    let(:params) {{ :mailaliases => ['foo','bar'] }}

    it do
      should contain_mailalias('root').with({
        'ensure'    => 'present',
        'recipient' => ['foo','bar'],
        'notify'    => 'Exec[root newaliases]',
      })
    end
  end

  context "mailaliases => 'foo'" do
    let(:params) {{ :mailaliases => 'foo' }}
    it { expect { should contain_mailalias('root') }.to raise_error(Puppet::Error, /is not an Array/) }
  end
end
