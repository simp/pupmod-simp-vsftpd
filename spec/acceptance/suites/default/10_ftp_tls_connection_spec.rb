require 'spec_helper_acceptance'

test_name 'ftp tls connection'

describe 'An FTP-over-TLS session' do
  hosts_with_role(hosts, 'server').each do |server|
    describe "with server '#{server}'" do
      # Why all the sudden this matters now, I have no idea :-|
      context 'system prep' do
        it 'allows ftpd_full_access in selinux' do
          on(server, 'setsebool -P ftpd_full_access=1', accept_all_exit_codes: true)
          on(server, 'setsebool -P allow_ftpd_full_access=1', accept_all_exit_codes: true)
        end
      end

      hosts_with_role(hosts, 'client').each do |client|
        describe "with client '#{client}'" do
          # Ensure that our test doesn't match messages from other tests
          let(:msg_uuid_tls) { Time.now.to_f.to_s.tr('.', '_') + '_TLS' }
          let(:client_fqdn) { fact_on(client, 'fqdn') }
          let(:server_fqdn) { fact_on(server, 'fqdn') }

          let(:client_manifest) do
            <<~EOS
              include 'iptables'

              iptables::listen::tcp_stateful { 'ssh':
                dports       => 22,
                trusted_nets => ['any'],
              }
              # ephemeral ports for FTP's "active mode"
              iptables::listen::tcp_stateful { 'ephemeral_ports':
                dports       => '32768:61000',
                trusted_nets => ['any'],
              }

              file { '/root/TEST.upload.#{msg_uuid_tls}':
                ensure  => 'file',
                content => '123',
                mode    => '644',
                owner   => 'root',
              }

              # A client to test the FTP connection
              package { 'lftp': ensure => present }
            EOS
          end

          let(:client_hieradata) do
            {
              'simp_options::firewall' => true,
              'simp_options::trusted_nets' => ['any'],
            }
          end

          let(:server_manifest) do
            <<~EOS
              # Switch firewall control from firewalld over to iptables in EL7
              # Presumably this would already be done on a running system.
              include 'iptables'
              iptables::listen::tcp_stateful { 'ssh':
                dports       => 22,
                trusted_nets => ['0.0.0.0/0'],
              }

              user { 'foo':
                password   => '$1$MpLw9Ljh$wCbneeNVSYQt8L3slbjrs.', # H35zUl5mA4Fiiy3KT
                home       => '/home/foo',
                managehome => true,
              }

              file { '/home/foo':
                ensure  => 'directory',
                owner   => 'foo',
                group   => 'foo',
                mode    => '0600'
              }
              ->
              file { '/home/foo/TEST.download.#{msg_uuid_tls}':
                ensure  => 'file',
                content => '456',
                mode    => '644',
                owner   => 'foo',
              }

              # install and start vsftpd with SSL
              class { 'vsftpd':
                local_enable  => true,
                ssl_enable    => true,
                pasv_min_port => 10000,
                pasv_max_port => 10100,
              }
            EOS
          end

          let(:server_hieradata) do
            {
              'simp_options::firewall' => true,
              'simp_options::pki' => true,
              'simp_options::pki::source' => '/etc/pki/simp-testing/pki',
              'simp_options::trusted_nets' => ['0.0.0.0/0'],
              'simp_options::auditd' => false,
            }
          end

          context 'puppet apply' do
            it 'configures server without errors' do
              set_hieradata_on(server, server_hieradata)
              apply_manifest_on(server, server_manifest, catch_failures: true)
            end

            it 'configures server idempotently' do
              apply_manifest_on(server, server_manifest, catch_changes: true)
            end

            it 'configures client without errors' do
              set_hieradata_on(client, client_hieradata)
              apply_manifest_on(client, client_manifest, catch_failures: true)
            end

            it 'configures client idempotently' do
              apply_manifest_on(client, client_manifest, catch_changes: true)
            end
          end

          context 'connection' do
            let(:lftp_config) do
              <<~EOM
                set ssl:ca-file "/etc/pki/simp-testing/pki/cacerts/cacerts.pem"
                set ssl:check-hostname true
                set ssl:key-file "/etc/pki//simp-testing/pki/private/#{client_fqdn}.pem"
                set ssl:cert-file "/etc/pki/simp-testing/pki/public/#{client_fqdn}.pub"
              EOM
            end
            let(:ftp_cmd) { "lftp --user=foo --password=H35zUl5mA4Fiiy3KT ftp://#{server_fqdn}" }

            it 'creates the lftp configuration' do
              homedir = on(client, 'echo $HOME').stdout.strip
              create_remote_file(client, "#{homedir}/.lftprc", lftp_config)
            end

            it 'successfullies log in a user using FTP-over-SSL' do
              on(client, "#{ftp_cmd} -e 'ls; exit'", acceptable_exit_codes: [0])
            end

            it 'successfullies download a file using FTP-over-SSL' do
              # selinux policy by default does not allow ftp in home directories
              bools = Hash[on(server, 'getsebool -a').stdout.split("\n").map { |x| x.split(%r{\s+-->\s+}) }]

              if bools.keys.include?('ftp_home_dir')
                on(server, 'setsebool -P ftp_home_dir=1')
              end

              on(client, "#{ftp_cmd} -e 'get TEST.download.#{msg_uuid_tls}; exit'", acceptable_exit_codes: [0])
            end

            it 'successfullies upload a file using FTP-over-SSL' do
              on(client, %(#{ftp_cmd} -e 'put /root/TEST.upload.#{msg_uuid_tls}; exit'), acceptable_exit_codes: [0])
            end
          end
        end
      end
    end
  end
end
