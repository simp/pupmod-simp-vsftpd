require 'spec_helper'

describe 'vsftpd' do

  context 'on the supported operating system' do
    on_supported_os.each do |os, facts|
      let(:facts){ facts }

      context "#{os}" do
        context 'with SIMP firewall managed' do
          let(:params) {{ :manage_firewall => true }}
          it { is_expected.to contain_class('vsftpd::config::firewall') }
        end

        context 'with SIMP firewall managed' do
          let(:params) {{ :manage_firewall => false }}
          it { is_expected.not_to contain_class('vsftpd::config::firewall') }
        end

        context 'with SIMP firewall management and listen_ipv4 => true' do
          let(:params) {{
            :manage_firewall => true,
            :listen_ipv4     => true,
          }}
          it { is_expected.to contain_iptables__add_tcp_stateful_listen('allow_vsftpd_data_port') }
          it { is_expected.to contain_iptables__add_tcp_stateful_listen('allow_vsftpd_listen_port') }
        end

        context 'with SIMP firewall management and pasv_enable => true' do
          let(:params) {{
            :manage_firewall => true,
            :pasv_enable     => true,
          }}
          it { is_expected.to contain_exec('check_conntrack_ftp') }
          it { is_expected.to contain_exec('nf_conntrack_ftp') }
        end


        context 'with SIMP distributing PKI certs' do
          let(:params) {{ :manage_pki => true }}
          it { is_expected.to contain_class('vsftpd::config::pki') }
          it { is_expected.to contain_pki__copy('/etc/vsftpd') }
        end

        context 'without SIMP distributing PKI certs' do
          let(:params) {{ :manage_pki => false }}
          it { is_expected.not_to contain_class('vsftpd::config::pki') }
          it { is_expected.not_to contain_pki__copy('/etc/vsftpd/pki') }
        end

        context 'with SIMP distributing PKI certs to a custom directory' do
          let(:params) {{
            :manage_pki   => true,
            :pki_certs_dir => '/opt/custom/cert/dir',
          }}
          it { is_expected.to contain_pki__copy('/opt/custom/cert/dir') }
        end

        context 'with SIMP managing TCP wrappers' do
          let(:params) {{ :manage_tcpwrappers => true }}
          it { is_expected.to contain_class('vsftpd::config::tcpwrappers') }
        end

        context 'without SIMP managing TCP wrappers' do
          let(:params) {{ :manage_tcpwrappers => false }}
          it { is_expected.not_to contain_class('vsftpd::config::tcpwrappers') }
        end
      end
    end
  end
end
