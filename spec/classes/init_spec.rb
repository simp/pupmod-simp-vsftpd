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
          it { is_expected.to create_class('vsftpd') }
          it { is_expected.to create_class('vsftpd::install') }
          it { is_expected.to create_class('vsftpd::config') }
          it { is_expected.to create_class('vsftpd::service') }

          # NOTE: these ::config:: expectations will reverse in SIMP 6
          it { is_expected.to create_class('vsftpd::config::firewall') }
          it { is_expected.to create_class('vsftpd::config::pki') }
          it { is_expected.to create_class('vsftpd::config::tcpwrappers') }

          it { is_expected.to contain_user('ftp') }
          it { is_expected.to contain_group('ftp') }
          it { is_expected.to contain_package('vsftpd').that_requires('Group[ftp]') }
          it { is_expected.to contain_package('vsftpd').that_requires('User[ftp]') }
          it { is_expected.to contain_service('vsftpd').with(:ensure => 'running') }

          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf') }
          it { is_expected.to contain_file('/etc/vsftpd') }
          it { is_expected.to contain_file('/etc/vsftpd/ftpusers') }
          it { is_expected.to contain_file('/etc/vsftpd/user_list') }
          it { is_expected.to contain_file('/etc/pam.d/vsftpd') }

          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[^userlist_enable=YES]) }
          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[^userlist_deny=YES]) }
          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').without_content(%r[^userlist_list=]) }
          it { is_expected.to contain_file('/etc/vsftpd/user_list').with_content(/^root\nbin\ndaemon\nadm\nlp\nsync\nshutdown\nhalt\nmail\nnews\nuucp\noperator\ngames\nnobody/) }
        end

        context 'installing software with custom ownership' do
          let(:params) {{
            :vsftpd_user  => 'vsftpd',
            :vsftpd_group => 'vsftpd',
          }}

          it { is_expected.to contain_user('vsftpd') }
          it { is_expected.to contain_group('vsftpd') }
          it { is_expected.to contain_package('vsftpd').that_requires('Group[vsftpd]') }
          it { is_expected.to contain_package('vsftpd').that_requires('User[vsftpd]') }
        end

        context 'with SSL enabled' do
          let(:params) {{ :ssl_enable  => true }}

          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[ssl_enable=YES]) }
          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[rsa_cert_file=/etc/vsftpd/pki/public/test.host.simp.pub]) }
          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[rsa_private_key_file=/etc/vsftpd/pki/private/test.host.simp.pem]) }
          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[ca_certs_file=/etc/vsftpd/pki/cacerts/cacerts.pem]) }
        end

        context 'with SSL disabled' do
          let(:params) {{ :ssl_enable  => false }}
          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[ssl_enable=NO]) }
        end

        context 'with a custom certificate directory location' do
          let(:params) {{ :pki_certs_dir => '/opt/custom/cert/dir' }}

          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[rsa_cert_file=/opt/custom/cert/dir/public/test.host.simp.pub]) }
          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[rsa_private_key_file=/opt/custom/cert/dir/private/test.host.simp.pem]) }
          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[ca_certs_file=/opt/custom/cert/dir/cacerts/cacerts.pem]) }
        end

        context 'with a custom user whitelist' do
          let(:params) {{
            :user_list     => ['foo', 'bar', 'baz'],
            :userlist_deny => false,
          }}

          it { is_expected.to contain_file('/etc/vsftpd/user_list').with_content(/^foo\nbar\nbaz/) }
          it { is_expected.to contain_file('/etc/vsftpd/user_list').without_content(/^root\n/) }
          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[^userlist_enable=YES]) }
          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[^userlist_deny=NO]) }
        end

        context 'with a disabled user list' do
          let(:params) {{ :userlist_enable => false }}
          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[^userlist_enable=NO]) }
        end

        context 'with PASV disabled ' do
          let(:params) {{ :pasv_enable => false }}
          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[^pasv_enable=NO]) }
        end

        context 'with PASV enabled ' do
          let(:params) {{ :pasv_enable => true }}
          it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[^pasv_enable=YES]) }

          context 'and firewall managed + PASV port range defined' do
            let(:params) {{
              :pasv_enable     => true,
              :pasv_min_port   => 10000,
              :pasv_max_port   => 10100,
              :manage_firewall => true,
              :client_nets     => 'any',
            }}
            it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[^pasv_min_port=10000]) }
            it { is_expected.to create_file('/etc/vsftpd/vsftpd.conf').with_content(%r[^pasv_max_port=10100]) }
            it { is_expected.to create_iptables__add_tcp_stateful_listen('allow_vsftpd_pasv_ports').with_dports(%r[^10000:10100]) }
          end

          context 'and firewall manages (but no min/max PASV ports specified)' do
            let(:params) {{
              :pasv_enable     => true,
              :manage_firewall => true,
              :client_nets     => 'any',
            }}
            it { is_expected.to_not create_iptables__add_tcp_stateful_listen('allow_vsftpd_pasv_ports').with_dports(%r[^10000:10100]) }
          end
        end
      end
    end
  end
end
