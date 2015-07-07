require 'spec_helper'

describe 'vsftpd' do

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      let(:facts) do
        facts
      end

      context "on #{os}" do
        it { should create_class('vsftpd') }
        it { should compile.with_all_deps }
        it { should create_class('vsftpd::install') }
        it { should create_class('vsftpd::config') }
        it { should create_class('vsftpd::service') }
        it { should create_class('vsftpd::config::firewall') }
        it { should create_class('vsftpd::config::pki') }
        it { should create_class('vsftpd::config::tcpwrappers') }
      end
    end
  end
end
