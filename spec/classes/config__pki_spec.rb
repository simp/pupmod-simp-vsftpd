### require 'spec_helper'
### 
### describe 'vsftpd' do
### 
###   context 'supported operating systems' do
###     on_supported_os.each do |os, facts|
###       let(:facts) { facts }
### 
###       context "on #{os}" do
###         context 'with SIMP distributing PKI certs' do
###           let(:params) {{ :manage_pki => true }}
###           it { is_expected.to create_class('vsftpd::config::pki') }
###           it { is_expected.to contain_pki__copy('/etc/vsftpd/pki') }
###         end
### 
###         context 'without SIMP distributing PKI certs' do
###           let(:params) {{ :manage_pki => false }}
###           it { is_expected.not_to create_class('vsftpd::config::pki') }
###         end
### 
###         context 'with SIMP distributing PKI certs to a custom directory' do
###           let(:params) {{
###             :manage_pki   => true,
###             :pki_certs_dir => '/opt/custom/cert/dir',
###           }}
###           it { is_expected.to contain_pki__copy('/opt/custom/cert/dir') }
###         end
###       end
### 
###     end
###   end
### end
