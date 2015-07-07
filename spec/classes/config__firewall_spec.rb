require 'spec_helper'

describe 'vsftpd::config::firewall' do

   let(:facts) { {
      :fqdn => 'spec.test',
      :uid_min => '500',
      :grub_version => '0.97',
      :hardwaremodel => 'x86_64',
      :operatingsystem => 'RedHat',
      :lsbmajdistrelease => '7',
      :operatingsystemmajrelease => '7',
      :interfaces => 'lo,eth0',
      :ipaddress_lo => '127.0.0.1',
      :ipaddress_eth0 => '1.2.3.4',
      :simp_version => '5.0.0'
  } }

  it { should create_class('vsftpd::config::firewall') }
  it { should compile.with_all_deps }

  context 'with listen_ipv4 true' do
    let(:params) { {:listen_ipv4 => true, :pasv_enable => false} }
    it { should contain_iptables__add_tcp_stateful_listen('allow_vsftpd_data_port') }
    it { should contain_iptables__add_tcp_stateful_listen('allow_vsftpd_listen_port') }

    context 'with pasv_enable => true' do
      let(:params) { {:pasv_enable => true} }
      it { should contain_exec('check_conntrack_ftp') }
      it { should contain_exec('nf_conntrack_ftp') }
    end
  end
end
