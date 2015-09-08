require 'spec_helper_acceptance'

test_name 'ftp connection'

describe 'An anonymous (plaintext) FTP session' do
  before(:all) do
    # Ensure that our test doesn't match messages from other tests
    @msg_uuid = @msg_uuid || {}
    @msg_uuid[__FILE__] = Time.now.to_f.to_s.gsub('.','_') + '_PLAINTEXT'
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
      # FTP and its ephemeral ports
      iptables::add_tcp_stateful_listen { 'ephemeral_ports':
        dports => '32768:61000',
        client_nets => 'any',
      }

      # A client to test the FTP connection
      # (curl gives nice exit codes and supports ftps)
      package{ 'curl': ensure => present }

      file{ '/root/TEST.upload.#{@msg_uuid[__FILE__]}':
        ensure  => 'file',
        content => '123',
        mode    => '644',
        owner   => 'root',
      }
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
      # FTP and its ephemeral ports
      iptables::add_tcp_stateful_listen { 'ephemeral_ports':
        dports => '32768:61000',
        client_nets => 'any',
      }

      # install and start vsftpd without SSL
      class { 'vsftpd':
        ssl_enable      => false,
        manage_firewall => true,
        pasv_enable     => true,
        pasv_min_port   => 10000,
        pasv_max_port   => 10100,
        client_nets     => 'any',
      }
      ->
      file{ '/var/ftp/pub/TEST.download.#{@msg_uuid[__FILE__]}':
        ensure  => 'file',
        content => '456',
        mode    => '644',
        owner   => 'root',
      }
    EOS
  }


  context 'basic puppet apply' do
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
    let(:curl_ftp_cmd){ "curl --verbose ftp://#{server_fqdn}/pub/" }

    it 'should successfully log in with active anonymous FTP' do
      on( client, "#{curl_ftp_cmd} -P -", :acceptable_exit_codes => [0] )
    end

    it 'should successfully download a file using anonymous FTP' do
      on( client, "#{curl_ftp_cmd}/TEST.download.#{@msg_uuid[__FILE__]}", :acceptable_exit_codes => [0] )
    end

    # anonymous FTP cannot upload by default
    it 'should fail to upload a file using anonymous FTP' do
      on( client, %Q(#{curl_ftp_cmd} -T /root/TEST.upload.#{@msg_uuid[__FILE__]}), :acceptable_exit_codes => [25] )
    end

    ### # NOTE: Commented out because FTP client is rediculous, but keeping in back
    ###         pocket because there's a chance we might want it and it was a PITA
    ###         to set up.  Remove before committing.
    ###  let(:netrc_template) {
    ###    <<-EOS
    ###machine SERVER
    ###        login LOGIN
    ###        password PASSWORD
    ###
    ###macdef connection_test
    ###        cd /pub
    ###        ls -la
    ###        quit
    ###
    ###macdef upload_test
    ###        cd /pub/tests
    ###        bin
    ###        put filename.tar.gz
    ###        quit
    ###
    ###    EOS
    ###  }
    # wget handles FTP and returns exit codes on failure
    # on( client, %Q(wget --no-passive-ftp --spider ftp://#{server_fqdn}/pub/), :acceptable_exit_codes => [0] )
    # curl handles FTP and returns exit codes on failure
    # stage a .netrc file
    ### netrc_text = netrc_template
    ###               .sub( 'SERVER',   server_fqdn   )
    ###               .sub( 'LOGIN',    'anonymous'   )
    ###               .sub( 'PASSWORD', 'foo@foo.foo' )
    ### apply_manifest_on(client, "file{'/root/.netrc': content => '#{netrc_text}' }", :catch_failures => true)

    ### connect to FTP server, then check log for FTP error codes
    ### on( client, %Q(echo "\\$ connection_test" | ftp #{server_fqdn} > connection_test.log) )
    ### on( client,
    ###    %Q(egrep '^(202|4[0-9][0-9]|5[0-9][0-9]|6|7|9)' connection_test.log),
    ###    :acceptable_exit_codes => [1]
    ###  )
  end
end
