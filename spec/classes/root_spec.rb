require 'spec_helper'

describe 'root' do
  shared_context :shared_authorized_keys do
    it do
      should contain_file('/root/.ssh/authorized_keys') \
        .with_content(/^foo$/) \
        .with_content(/^bar$/)
    end
  end

  let(:facts) {
    {
      :osfamily => 'RedHat',
      :operatingsystemrelease => '6.4'
    }
  }

  it do
    should contain_file('/root').with({
      'ensure'  => 'directory',
      'path'    => '/root',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0550'
    })
  end

  it do
    should contain_file('/root/.ssh').with({
      'ensure'  => 'directory',
      'path'    => '/root/.ssh',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0700',
      'require' => 'File[/root]'
    })
  end

  it do
    should contain_file('/root/.ssh/authorized_keys').with({
      'ensure'  => 'present',
      'path'    => '/root/.ssh/authorized_keys',
      'content' => nil,
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0600',
      'require' => 'File[/root/.ssh]'
    })
  end

  context "authorized_keys as array" do
    let(:params) do
      {
        :authorized_keys => [
          'foo',
          'bar',
        ],
      }
    end

    include_context :shared_authorized_keys
  end

  context "authorized_keys as list" do
    let(:params) do
      {
        :authorized_keys => 'foo,bar',
      }
    end
    
    include_context :shared_authorized_keys
  end
  
  context "authorized_keys as top-scope variable root_authorized_keys" do
    let(:facts) {
      {
        :osfamily => 'RedHat',
        :operatingsystemrelease => '6.4',
        :root_authorized_keys => 'foo,bar',
      }
    }
    
    let(:params) do
      {
      }
    end
    
    include_context :shared_authorized_keys
  end
end
