# root_sshrsakey.rb

require 'facter/util/file_read'

root_sshrsakey_path = '/root/.ssh/id_rsa.pub'

Facter.add(:root_sshrsakey) do
  confine :kernel => 'Linux'
  setcode do
    value = nil
    if FileTest.file?(root_sshrsakey_path)
      begin
        value = Facter::Util::FileRead.read(root_sshrsakey_path).split(/\s+/)[1]
      rescue
        value = nil
      end
    end

    value
  end
end
