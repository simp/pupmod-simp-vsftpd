require 'spec_helper'

describe 'vsftpd' do

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
      :ipaddress_eth0 => '1.2.3.4',
      :simp_version => '4.1.0'
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
      :ipaddress_eth0 => '1.2.3.4',
      :simp_version => '5.0.0'
    }
  }

  shared_examples_for "a fact set init" do
    it { should compile.with_all_deps }
    it { should create_class('vsftpd') }
    it { should contain_package('vsftpd') }
    it { should contain_user('ftp') }

    it { should contain_file('/etc/vsftpd') }
    it { should contain_file('/etc/vsftpd/ftpusers') }
    it { should contain_file('/etc/vsftpd/user_list') }
    it { should contain_file('/etc/pam.d/vsftpd') }
    it { should contain_pki__copy('/etc/vsftpd') }
  end

  describe "RHEL 6" do
    it_behaves_like "a fact set init"
    let(:facts) {base_facts['RHEL 6']}

    it { should contain_group('vsftpd') }
  end

  describe "RHEL 7" do
    it_behaves_like "a fact set init"
    let(:facts) {base_facts['RHEL 7']}

    it { should contain_group('ftp') }
  end

end
