# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'root class:' do
  context 'with default parameters' do
    it 'runs successfully' do
      pp = <<-PP
        class { 'root': }
      PP

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/root') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode 550 }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end

    describe file('/root/.ssh') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode 700 }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end

    describe file('/root/.ssh/authorized_keys') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 600 }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      its(:content) { is_expected.to match %r{^$} }
    end

    describe file('/etc/aliases') do
      its(:content) { is_expected.not_to match %r{^root:} }
    end
  end

  context 'when mailaliases defined' do
    it 'runs successfully' do
      pp = <<-PP
        package { 'postfix': ensure => present }->
        augeas { 'inet_protocols ipv4':
          changes => 'set inet_protocols ipv4',
          lens    => 'Postfix_main.lns',
          incl    => '/etc/postfix/main.cf',
        }->
        class { 'root': mailaliases => [ 'foo@bar.com' ] }
      PP

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/etc/aliases') do
      its(:content) { is_expected.to match %r{^root:\s+foo@bar.com$} }
    end
  end
end
