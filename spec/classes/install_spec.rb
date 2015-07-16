require 'spec_helper'

describe 'vsftpd::install' do

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      let(:facts) do
        facts
      end

      context "on #{os}" do
        it { is_expected.to create_class('vsftpd::install') }
        it { is_expected.to compile.with_all_deps }

        let(:params){{:vsftpd_group => 'ftp', :vsftpd_user => 'ftp'}}
        it { is_expected.to contain_group('ftp') }
        it { is_expected.to contain_package('vsftpd').that_requires('Group[ftp]') }
        it { is_expected.to contain_package('vsftpd').that_requires('User[ftp]') }
      end
    end
  end
end
