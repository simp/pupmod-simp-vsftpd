require 'spec_helper'

describe 'vsftpd::config::pki' do

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      let(:facts) do
        facts
      end

      context "on #{os}" do
        it { should create_class('vsftpd::config::pki') }
        it { should compile.with_all_deps }
        it { should contain_pki__copy('/etc/vsftpd') }
      end
    end
  end
end
