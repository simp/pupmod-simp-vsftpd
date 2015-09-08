### require 'spec_helper'
### 
### describe 'vsftpd' do
### 
###   context 'on the supported operating system' do
###     on_supported_os.each do |os, facts|
###       let(:facts){ facts }
### 
###       context "#{os}" do
###         context 'with firewall enabled' do
###           let(:params) {{ :manage_firewall => true }}
###           it { is_expected.to contain_class('vsftpd::config::firewall') }
###         end
### 
###         context 'with firewall disabled' do
###           let(:params) {{ :manage_firewall => false }}
###           it { is_expected.not_to contain_class('vsftpd::config::firewall') }
###         end
### 
###         context 'with firewall enabled and listen_ipv4 => true' do
###           let(:params) {{
###             :manage_firewall => true,
###             :listen_ipv4     => true,
###           }}
###           it { is_expected.to contain_iptables__add_tcp_stateful_listen('allow_vsftpd_data_port') }
###           it { is_expected.to contain_iptables__add_tcp_stateful_listen('allow_vsftpd_listen_port') }
###         end
### 
###         context 'with firewall enabled and pasv_enable => true' do
###           let(:params) {{
###             :manage_firewall => true,
###             :pasv_enable     => true,
###           }}
###           it { is_expected.to contain_exec('check_conntrack_ftp') }
###           it { is_expected.to contain_exec('nf_conntrack_ftp') }
###         end
###       end
###     end
###   end
### end
