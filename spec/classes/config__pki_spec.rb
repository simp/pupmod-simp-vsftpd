require 'spec_helper'

describe 'vsftpd::config::pki' do

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      let(:facts) do
        facts
      end

      context "on #{os}" do
        it { is_expected.to create_class('vsftpd::config::pki') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_pki__copy('/etc/vsftpd') }
      end
    end
  end
end
