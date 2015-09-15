### require 'spec_helper'
###
### describe 'vsftpd::config' do
###
###   context 'supported operating systems' do
###     on_supported_os.each do |os, facts|
###       let(:facts) do
###         facts
###       end
###
###       context "on #{os}" do
###         it { is_expected.to compile.with_all_deps }
###         it { is_expected.to create_class('vsftpd::config') }
###
###         it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf') }
###         it { is_expected.to contain_file('/etc/vsftpd') }
###         it { is_expected.to contain_file('/etc/vsftpd/ftpusers') }
###         it { is_expected.to contain_file('/etc/vsftpd/user_list') }
###         it { is_expected.to contain_file('/etc/pam.d/vsftpd') }
###       end
###     end
###   end
### end
