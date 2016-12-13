require 'spec_helper_acceptance'

test_name 'vsftpd class'

describe 'vsftpd class' do
  let(:client){ only_host_with_role( hosts, 'client' ) }
  let(:server){ only_host_with_role( hosts, 'server' ) }

  let(:manifest) {
    <<-EOS
      class { 'vsftpd':
         pki                 => false,
         app_pki_cert_source => '/etc/pki/simp-testing',
      }
    EOS
  }

  context 'default parameters (no pki)' do

    it 'should install epel' do
      install_package(server, 'epel-release')
    end

    it 'should work with no errors' do
      apply_manifest_on(server, manifest, :catch_failures => true)
    end

    it 'should be idempotent' do
      apply_manifest_on(server, manifest, {:catch_changes => true})
    end

    describe package('vsftpd') do
      it { is_expected.to be_installed }
    end

    describe service('vsftpd') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    it 'should be listening on port 21' do
      on server, "netstat -ntap | grep '^tcp.* 0.0.0.0:21 .*/vsftpd'", :acceptable_exit_codes => [0]
    end
  end
end
