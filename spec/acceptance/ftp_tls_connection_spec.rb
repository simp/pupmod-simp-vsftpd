require 'spec_helper_acceptance'

test_name 'ftp tls connection'

describe 'An FTP-over-TLS session' do
  before(:all) do
    # Ensure that our test doesn't match messages from other tests
    @msg_uuid = @msg_uuid || {}
    @msg_uuid[__FILE__] = Time.now.to_f.to_s.gsub('.','_') + '_TLS'
  end

  let(:client){ only_host_with_role( hosts, 'client' ) }
  let(:server){ only_host_with_role( hosts, 'server' ) }
  let(:client_fqdn){ fact_on( client, 'fqdn' ) }
  let(:server_fqdn){ fact_on( server, 'fqdn' ) }

  let(:client_manifest) {
    <<-EOS
      # Switch firewall control from firewalld over to iptables in EL7
      # Presumably this would already be done on a runnying system.
      include 'iptables'
      iptables::add_tcp_stateful_listen { 'ssh':
        dports => '22',
        client_nets => 'any',
      }
      # ephemeral ports for FTP's "active mode"
      iptables::add_tcp_stateful_listen { 'ephemeral_ports':
        dports => '32768:61000',
        client_nets => 'any',
      }

      file{ '/root/TEST.upload.#{@msg_uuid[__FILE__]}':
        ensure  => 'file',
        content => '123',
        mode    => '644',
        owner   => 'root',
      }

      # A client to test the FTP connection
      # (curl gives nice exit codes and supports FTP-over-SSL)
      package{ 'curl': ensure => present }
    EOS
  }

  let(:server_manifest) {
    <<-EOS
      # Switch firewall control from firewalld over to iptables in EL7
      # Presumably this would already be done on a runnying system.
      include 'iptables'
      iptables::add_tcp_stateful_listen { 'ssh':
        dports => '22',
        client_nets => 'any',
      }

      user{ 'foo':
        password => '$1$UR6BGI5k$GMXMBABoo0SI5LHnkYdfb0', # foo
        home     => '/home/foo',
        managehome => true,
      }

      file{ '/home/foo':
        ensure => 'directory',
        owner => 'foo',
        group => 'foo',
        mode => '0600',
      }
      ->
      file{ '/home/foo/TEST.download.#{@msg_uuid[__FILE__]}':
        ensure  => 'file',
        content => '456',
        mode    => '644',
        owner   => 'foo',
      }


      # install and start vsftpd with SSL
      class { 'vsftpd':
        ssl_enable        => true,
        pki_certs_dir     => '/etc/pki/simp-testing',
        local_enable      => true,
        manage_firewall   => true,
        pasv_enable       => true,
        pasv_min_port     => 10000,
        pasv_max_port     => 10100,
        client_nets       => 'any',
        require_ssl_reuse => false, # NOTE: curl doesn't support SSL reuse
      }
    EOS
  }


  context 'puppet apply' do
    it 'should configure server without errors' do
      apply_manifest_on(server, server_manifest, :catch_failures => true)
    end

    it 'should configure server idempotently' do
      apply_manifest_on(server, server_manifest, :catch_changes => true)
    end

    it 'should configure client without errors' do
      apply_manifest_on(client, client_manifest, :catch_failures => true)
    end

    it 'should configure client idempotently' do
      apply_manifest_on(client, client_manifest, :catch_changes => true)
    end
  end

  context 'connection' do
    let(:curl_ftp_cmd) {
      'curl --verbose --cacert /etc/pki/simp-testing/cacerts/cacerts.pem ' +
      "--key /etc/pki//simp-testing/private/#{client_fqdn}.pem " +
      "--cert /etc/pki/simp-testing/public/#{client_fqdn}.pub " +
      "--ftp-ssl ftp://foo:foo@#{server_fqdn}"
      # ^^ these arguments are deprecated in modern curl, but EL6 needs them.
      # In the future, '--ssl --ss-reqd' should replace '--ftp-ssl' here
    }

    it 'should successfully log in a user using FTP-over-SSL' do
      on( client, curl_ftp_cmd, :acceptable_exit_codes => [0] )
    end

    it 'should successfully download a file using FTP-over-SSL' do
      on( client, "#{curl_ftp_cmd}/TEST.download.#{@msg_uuid[__FILE__]}", :acceptable_exit_codes => [0] )
    end

    it 'should successfully upload a file using FTP-over-SSL' do
      on( client, %Q(#{curl_ftp_cmd} -T /root/TEST.upload.#{@msg_uuid[__FILE__]}), :acceptable_exit_codes => [0] )
    end
  end
end
