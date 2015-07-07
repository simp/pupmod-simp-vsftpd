require 'spec_helper'

describe 'vsftpd::install' do

#  base_facts = {
#    "RHEL 6" => {
#      :fqdn => 'spec.test',
#      :uid_min => '500',
#      :grub_version => '0.97',
#      :hardwaremodel => 'x86_64',
#      :operatingsystem => 'RedHat',
#      :lsbmajdistrelease => '6',
#      :operatingsystemmajrelease => '6',
#      :interfaces => 'lo,eth0',
#      :ipaddress_lo => '127.0.0.1',
#      :ipaddress_eth0 => '1.2.3.4',
#      :simp_version => '4.1.0'
#    },
#    "RHEL 7" => {
#      :fqdn => 'spec.test',
#      :uid_min => '500',
#      :grub_version => '0.97',
#      :hardwaremodel => 'x86_64',
#      :operatingsystem => 'RedHat',
#      :lsbmajdistrelease => '7',
#      :operatingsystemmajrelease => '7',
#      :interfaces => 'lo,eth0',
#      :ipaddress_lo => '127.0.0.1',
#      :ipaddress_eth0 => '1.2.3.4',
#      :simp_version => '5.0.0'
#    }
#  }

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

  it { should create_class('vsftpd::install') }
  it { should compile.with_all_deps }

  let(:params){{:vsftpd_group => 'ftp', :vsftpd_user => 'ftp'}}
  it { should contain_group('ftp') }
  it { should contain_package('vsftpd').that_requires('Group[ftp]') }

#  describe "RHEL 6" do
#    let(:facts) {base_facts['RHEL 6']}
#    it { should contain_group('vsftpd') }
#  end
#
#  describe "RHEL 7" do
#    let(:facts) {base_facts['RHEL 7']}
#    it { should contain_group('ftp') }
#  end

end
