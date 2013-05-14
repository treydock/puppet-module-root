require 'spec_helper_system'

describe 'root class does not overwrite ssh_authorized_key type by default:' do
  context 'no params:' do
    let(:pp) do
      pp = <<-EOS
      ssh_authorized_key { 'test@localhost':
        ensure    => present,
        type      => 'ssh-rsa',
        user      => 'root',
        key       => 'foo',
      }
      class { 'root': }
      EOS
    end

    it 'should run with no errors' do
      puppet_apply(pp) do |r|
        r[:stderr].should == ''
        r[:exit_code].should_not eq(1)
      end
    end

    it 'should be idempotent' do
      puppet_apply(pp) do |r|
        r[:stderr].should == ''
        r[:exit_code].should == 0
      end
    end

    it 'should contain the foo key' do
      system_run('grep -q "ssh-rsa foo test@localhost" /root/.ssh/authorized_keys') do |r|
        r[:exit_code].should eq(0)
      end
    end
  end
end