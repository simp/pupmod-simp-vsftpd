require 'spec_helper'

describe 'vsftpd::config::firewall' do

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      let(:facts) do
        facts
      end

      context "on #{os}" do

        it { should create_class('vsftpd::config::firewall') }
        it { should compile.with_all_deps }

        context 'with listen_ipv4 true' do
          let(:params) { {:listen_ipv4 => true, :pasv_enable => false} }
          it { should contain_iptables__add_tcp_stateful_listen('allow_vsftpd_data_port') }
          it { should contain_iptables__add_tcp_stateful_listen('allow_vsftpd_listen_port') }
        end

        context 'with pasv_enable => true' do
          let(:params) { {:pasv_enable => true} }
          it { should contain_exec('check_conntrack_ftp') }
          it { should contain_exec('nf_conntrack_ftp') }
        end
      end
    end
  end
end
