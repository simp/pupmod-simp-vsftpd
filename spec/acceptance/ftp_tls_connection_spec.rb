require 'spec_helper_acceptance'
require 'tmpdir'

test_name 'ftp connection'

describe 'client -> server connection (TLS)' do
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
      # FTP and its ephemeral ports
      iptables::add_tcp_stateful_listen { 'ephemeral_ports':
        dports => '32768:61000',
        client_nets => 'any',
      }

      # A client to test the FTP connection
      # (curl gives nice exit codes and supports ftps)
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
    ###  # FTP and its ephemeral ports
    ###  iptables::add_tcp_stateful_listen { 'ephemeral_ports':
    ###    dports => '32768:61000',
    ###    client_nets => 'any',
    ###  }


      file{ '/home/foo':
        ensure => 'directory',
        owner => 'foo',
        group => 'foo',
        mode => '0600',
      }

      user{ 'foo':
        password => '$1$UR6BGI5k$GMXMBABoo0SI5LHnkYdfb0', # foo
        home     => '/home/foo',
        managehome => true,
      }


      # install and start vsftpd with SSL
      class { 'vsftpd':
        ssl_enable      => true,
        pki_certs_dir   => '/etc/pki/simp-testing',
        local_enable    => true,
        manage_firewall => true,
        pasv_enable     => true,
        pasv_min_port   => 10000,
        pasv_max_port   => 10100,

        # XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        # XXXXX  FIXME: THESE PARAMETERS DON'T LOOK LIKE THEY DO ANYTHING XXXXX
        # XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        client_nets     => 'any',
        allowed_nets    => 'any',
        # XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      }
    EOS
  }


  context 'client -> server (TLS)' do
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

    it 'should successfully log in a user using FTP-over-SSL' do
      require 'pry'; binding.pry
      # curl handles FTP and returns exit codes on failure
      on( client, %Q(curl --verbose --cacert /etc/pki/simp-testing/cacerts/cacerts.pem --key /etc/pki//simp-testing/private/#{client_fqdn}.pem --cert /etc/pki/simp-testing/public/#{client_fqdn}.pub --ftp-ssl ftp://foo:foo@#{server_fqdn}/pub:21), :acceptable_exit_codes => [0] )
    end

  end
end
