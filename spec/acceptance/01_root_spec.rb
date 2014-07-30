require 'spec_helper_acceptance'

describe 'root class:' do
  context 'default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
        class { 'root': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/root') do
      it { should be_directory }
      it { should be_mode 550 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/root/.ssh') do
      it { should be_directory }
      it { should be_mode 700 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/root/.ssh/authorized_keys') do
      it { should be_file }
      it { should be_mode 600 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its(:content) { skip("The purge_ssh_keys is not working in 3.6.2") { should match /^$/ } }
    end

    describe file('/etc/aliases') do
      its(:content) { should_not match /^root:/ }
    end
  end

  context 'when mailaliases defined' do
    it 'should run successfully' do
      pp = <<-EOS
        class { 'root': mailaliases => [ 'foo@bar.com' ] }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/aliases') do
      its(:content) { should match /^root:\s+foo@bar.com$/ }
    end
  end
end
