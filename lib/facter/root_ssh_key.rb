# frozen_string_literal: true

# root_ssh_key.rb

Facter.add(:root_ssh_key) do
  confine kernel: 'Linux'
  setcode do
    ssh_key_paths = {
      'dsa' => '/root/.ssh/id_dsa.pub',
      'rsa' => '/root/.ssh/id_rsa.pub',
      'ecdsa' => '/root/.ssh/id_ecdsa.pub',
      'ecdsa-sk' => '/root/.ssh/id_ecdsa_sk.pub',
      'ed25519' => '/root/.ssh/id_ed25519.pub',
      'ed25519-sk' => '/root/.ssh/id_ed25519_sk.pub'
    }

    value = {}
    ssh_key_paths.each_pair do |key_type, key_path|
      if File.exist?(key_path)
        pubkey = Facter::Util::Resolution.exec("cat #{key_path}").split(%r{\s+})
        value[key_type] = pubkey[1] if pubkey.size >= 2
      end
    end
    value
  end
end
