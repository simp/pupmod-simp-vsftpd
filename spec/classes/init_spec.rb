require 'spec_helper'

describe 'vsftpd' do

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      let(:facts) do
        facts
      end

      context "on #{os}" do
        it { is_expected.to create_class('vsftpd') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('vsftpd::install') }
        it { is_expected.to create_class('vsftpd::config') }
        it { is_expected.to create_class('vsftpd::service') }
        it { is_expected.to create_class('vsftpd::config::firewall') }
        it { is_expected.to create_class('vsftpd::config::pki') }
        it { is_expected.to create_class('vsftpd::config::tcpwrappers') }
      end
    end
  end
end
