require 'spec_helper'

describe 'root' do

  let(:facts) {
    {
      :osfamily => 'RedHat',
      :operatingsystemrelease => '6.4'
    }
  }

  let(:params) do
    {
      :authorized_keys => [
        'foo',
        'bar',
      ],
    }
  end

  it do
    should contain_file('/root').with({
      'ensure'  => 'directory',
      'path'    => '/root',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0750'
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
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0600',
      'require' => 'File[/root/.ssh]'
    })
  end

  it "should generate a template for /root/.ssh/authorized_keys" do
    content = catalogue.resource('file', "/root/.ssh/authorized_keys").send(:parameters)[:content]
    content.should match "^foo$"
    content.should match "^bar$"
  end
  
  context "authorized_keys as list" do
    let(:params) do
      {
        :authorized_keys => 'foo,bar',
      }
    end
    
    it "should generate a template for /root/.ssh/authorized_keys" do
      content = catalogue.resource('file', "/root/.ssh/authorized_keys").send(:parameters)[:content]
      content.should match "^foo$"
      content.should match "^bar$"
    end
  end
end
