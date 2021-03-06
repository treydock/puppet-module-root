# root_sshrsakey.rb

Facter.add(:root_sshrsakey) do
  confine kernel: 'Linux'
  setcode do
    root_sshrsakey_path = '/root/.ssh/id_rsa.pub'
    value = nil
    if FileTest.file?(root_sshrsakey_path)
      begin
        value = Facter::Util::Resolution.exec("cat #{root_sshrsakey_path}").split(%r{\s+})[1]
      rescue
        value = nil
      end
    end

    value
  end
end
