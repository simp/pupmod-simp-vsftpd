require 'spec_helper'

describe 'vsftpd::conf' do

  base_facts = {
    "RHEL 6" => {
      :fqdn => 'spec.test',
      :uid_min => '500',
      :grub_version => '0.97',
      :hardwaremodel => 'x86_64',
      :operatingsystem => 'RedHat',
      :lsbmajdistrelease => '6',
      :operatingsystemmajrelease => '6',
      :interfaces => 'lo,eth0',
      :ipaddress_lo => '127.0.0.1',
      :ipaddress_eth0 => '1.2.3.4'
    },
    "RHEL 7" => {
      :fqdn => 'spec.test',
      :uid_min => '500',
      :grub_version => '0.97',
      :hardwaremodel => 'x86_64',
      :operatingsystem => 'RedHat',
      :lsbmajdistrelease => '7',
      :operatingsystemmajrelease => '7',
      :interfaces => 'lo,eth0',
      :ipaddress_lo => '127.0.0.1',
      :ipaddress_eth0 => '1.2.3.4'
    }
  }

  shared_examples_for "a fact set conf" do
    let(:params) { {:listen_ipv4 => false, :pasv_enable => false, :tcp_wrappers => false} }

    it { should compile.with_all_deps }
    it { should create_class('vsftpd::conf') }

    it { should create_file('/etc/vsftpd/vsftpd.conf') }

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

    context 'with tcp_wrappers true' do
      let(:params) { {:tcp_wrappers => true} }
      it { should contain_tcpwrappers__allow('vsftpd') }
    end
  end


  describe "RHEL 6" do
    it_behaves_like "a fact set conf"
    let(:facts) {base_facts['RHEL 6']}
  end

  describe "RHEL 7" do
    it_behaves_like "a fact set conf"
    let(:facts) {base_facts['RHEL 7']}
  end

end
