### require 'spec_helper'
### 
### describe 'vsftpd' do
### 
###   context 'supported operating systems' do
###     on_supported_os.each do |os, facts|
###       let(:facts){ facts }
### 
###       context "#{os}" do
###         context 'with SIMP managing TCP wrappers' do
###           let(:params) {{ :manage_tcpwrappers => true }}
### 
###           it { is_expected.to compile.with_all_deps }
###           it { is_expected.to create_class('vsftpd::config::tcpwrappers') }
###           it { is_expected.to contain_tcpwrappers__allow('vsftpd') }
###         end
###       end
###     end
###   end
### end
