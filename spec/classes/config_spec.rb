require 'spec_helper'

describe 'vsftpd::config' do

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

  it { should compile.with_all_deps }
  it { should create_class('vsftpd::config') }

  it { should create_file('/etc/vsftpd/vsftpd.conf') }
  it { should contain_file('/etc/vsftpd') }
  it { should contain_file('/etc/vsftpd/ftpusers') }
  it { should contain_file('/etc/vsftpd/user_list') }
  it { should contain_file('/etc/pam.d/vsftpd') }

end
