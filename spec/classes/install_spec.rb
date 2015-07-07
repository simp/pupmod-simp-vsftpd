require 'spec_helper'

describe 'vsftpd::install' do

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      let(:facts) do
        facts
      end

      context "on #{os}" do
        it { should create_class('vsftpd::install') }
        it { should compile.with_all_deps }

        let(:params){{:vsftpd_group => 'ftp', :vsftpd_user => 'ftp'}}
        it { should contain_group('ftp') }
        it { should contain_package('vsftpd').that_requires('Group[ftp]') }
      end
    end
  end
end
