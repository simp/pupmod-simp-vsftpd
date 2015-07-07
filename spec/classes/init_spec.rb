require 'spec_helper'

describe 'vsftpd' do

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

  it { should create_class('vsftpd') }
  it { should compile.with_all_deps }
  it { should create_class('vsftpd::install') }
  it { should create_class('vsftpd::config') }
  it { should create_class('vsftpd::service') }
  it { should create_class('vsftpd::config::firewall') }
  it { should create_class('vsftpd::config::pki') }
  it { should create_class('vsftpd::config::tcpwrappers') }

end
