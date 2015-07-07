require 'spec_helper'

describe 'vsftpd::service' do

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      let(:facts) do
        facts
      end

      context "on #{os}" do
        it { should create_class('vsftpd::service') }
        it { should compile.with_all_deps }
        it { should contain_service('vsftpd').with(:ensure => 'running') }
      end
    end
  end
end
