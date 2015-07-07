require 'spec_helper'

describe 'vsftpd::config' do

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      let(:facts) do
        facts
      end

      context "on #{os}" do
        it { should compile.with_all_deps }
        it { should create_class('vsftpd::config') }

        it { should create_file('/etc/vsftpd/vsftpd.conf') }
        it { should contain_file('/etc/vsftpd') }
        it { should contain_file('/etc/vsftpd/ftpusers') }
        it { should contain_file('/etc/vsftpd/user_list') }
        it { should contain_file('/etc/pam.d/vsftpd') }
      end
    end
  end
end
