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

        it { is_expected.to contain_group('vsftpd') }
        it { is_expected.to contain_package('vsftpd').that_requires('Group[vsftpd]') }
        it { is_expected.to contain_package('vsftpd').that_requires('User[vsftpd]') }
      end
    end
  end
end
