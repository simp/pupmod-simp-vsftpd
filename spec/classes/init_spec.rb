require 'spec_helper'

describe 'vsftpd' do

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      let(:facts) do
        facts.merge( { :fqdn => 'test.host.simp' } )
      end

      context "on #{os}" do
        context "with default parameters" do
          let(:params) {{ }}
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('vsftpd') }
          it { is_expected.to contain_class('vsftpd::params') }
          it { is_expected.to_not contain_class('haveged') }
          it { is_expected.to contain_class('vsftpd::install') }
          it { is_expected.to contain_class('vsftpd::config') }
          it { is_expected.to contain_class('vsftpd::service') }

          it { is_expected.to_not contain_class('vsftpd::config::firewall') }
          it { is_expected.to_not contain_pki__copy('vsftpd') }
          it { is_expected.to_not contain_class('vsftpd::config::tcpwrappers') }

          it { is_expected.to contain_user('ftp') }
          it { is_expected.to contain_group('ftp') }
          it { is_expected.to contain_package('vsftpd').that_requires('Group[ftp]') }
          it { is_expected.to contain_package('vsftpd').that_requires('User[ftp]') }
          it { is_expected.to contain_service('vsftpd').with(:ensure => 'running') }
          it { is_expected.to create_file('/etc/ftpusers') }
          it { is_expected.to create_ftpusers('/etc/ftpusers').with({
            :min_id => '500'
          }) }
        end

        context 'with haveged enabled' do
          context 'with ssl enabled (by default)' do
            let(:params) {{ :haveged => true }}
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class('haveged') }
          end

          context 'with ssl not enabled' do
            let(:params) {{ :haveged => true, :ssl_enable => false }}
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to_not contain_class('haveged') }
          end
        end

        context 'when customizing install' do
          context 'when not managing vsftpd group' do
            let(:params) {{ :manage_group => false }}

            it { is_expected.to contain_user('ftp') }
            it { is_expected.to_not contain_group('ftp') }
            it { is_expected.to_not contain_package('vsftpd').that_requires('Group[ftp]') }
            it { is_expected.to_not contain_package('vsftpd').that_requires('User[ftp]') }
          end

          context 'when not managing vsftpd user' do
            let(:params) {{ :manage_user => false }}
            it { is_expected.to_not contain_user('ftp') }
            it { is_expected.to contain_group('ftp') }
            it { is_expected.to_not contain_package('vsftpd').that_requires('Group[ftp]') }
            it { is_expected.to_not contain_package('vsftpd').that_requires('User[ftp]') }
          end

          context 'when installing software with custom ownership' do
            let(:params) {{
              :vsftpd_user  => 'vsftpd',
              :vsftpd_group => 'vsftpd',
            }}
            it { is_expected.to contain_user('vsftpd') }
            it { is_expected.to contain_group('vsftpd') }
            it { is_expected.to contain_package('vsftpd').that_requires('Group[vsftpd]') }
            it { is_expected.to contain_package('vsftpd').that_requires('User[vsftpd]') }
          end
        end

        context 'with firewall enabled' do
          context 'with defaults (but no min/max PASV ports specified)' do
            let(:params) {{ :firewall => true }}
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class('vsftpd::config::firewall') }
            it { is_expected.to contain_class('iptables') }
            it { is_expected.to contain_iptables__listen__tcp_stateful('allow_vsftpd_data_port').with(:dports => '20') }
            it { is_expected.to contain_iptables__listen__tcp_stateful('allow_vsftpd_listen_port').with(:dports => '21') }
            it { is_expected.to_not contain_iptables__listen__tcp_stateful('allow_vsftpd_pasv_ports') }
            it { is_expected.to contain_exec('check_conntrack_ftp') }
            it { is_expected.to contain_exec('nf_conntrack_ftp') }
          end

          context 'PASV port range defined' do
            let(:params) {{
              :firewall => true,
              :pasv_min_port   => 10000,
              :pasv_max_port   => 10100
            }}
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_iptables__listen__tcp_stateful('allow_vsftpd_pasv_ports').with_dports(%r[^10000:10100]) }
          end

          context 'only pasv_min_port defined' do
            let(:params) {{
              :firewall => true,
              :pasv_min_port   => 10000,
            }}
            it { is_expected.to_not compile.with_all_deps }
          end

          context 'only pasv_max_port defined' do
            let(:params) {{
              :firewall => true,
              :pasv_max_port   => 10100
            }}
            it { is_expected.to_not compile.with_all_deps }
          end

          context 'with listen_ipv4 => false' do
            let(:params) {{ :firewall => true, :listen_ipv4 => false }}
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class('vsftpd::config::firewall') }
            it { is_expected.to_not contain_class('iptables') }
          end
        end

        context 'with pki enabled' do
          let(:params) {{ :pki => 'simp' }}
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('pki') }
          it { is_expected.to contain_pki__copy('vsftpd').with(
           :group => 'ftp'
          ) }
        end

        context 'with tcpwrappers enabled' do
          let(:params) {{ :tcpwrappers => true }}
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('vsftpd::config::tcpwrappers') }
          it { is_expected.to contain_class('tcpwrappers') }
          it { is_expected.to contain_tcpwrappers__allow('vsftpd').with(
            :pattern => ['192.168.122.0/24']
          ) }
        end
      end
    end
  end
end
