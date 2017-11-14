require 'spec_helper_acceptance'

test_name 'vsftpd class'

['6', '7'].each do |os_major_version|
  describe "vsftpd class for CentOS #{os_major_version}" do
    let(:client) { only_host_with_role( hosts, "client#{os_major_version}" ) }
    let(:server) { only_host_with_role( hosts, "server#{os_major_version}" ) }

    let(:manifest) { "include 'vsftpd'"}

    let(:hieradata) {
      <<-EOS
       simp_options::pki: true
       simp_options::pki::source: '/etc/pki/simp-testing/pki'
      EOS
    }

    context 'setup' do
      it 'should install epel' do
        install_package(server, 'epel-release')
      end
    end

    context 'default parameters with SIMP pki' do

      it 'should work with no errors' do
        set_hieradata_on(server, hieradata)
        apply_manifest_on(server, manifest, :catch_failures => true)
        # /etc/ftpusers has a permission and context change
        apply_manifest_on(server, manifest, :catch_failures => true)
      end

      it 'should be idempotent' do
        apply_manifest_on(server, manifest, {:catch_changes => true})
      end

      it 'should have vsftpd package installed' do
         expect(check_for_package(server, 'vsftpd')).to eq true
      end

      it 'should have vsftpd service enabled and running' do
        result = on(server, 'puppet resource service vsftpd')
        expect(result.stdout).to match(/ensure => 'running'/)
        expect(result.stdout).to match(/enable => 'true'/)
      end

      it 'should be listening on port 21' do
        on(server, "netstat -ntap | grep '^tcp.* 0.0.0.0:21 .*/vsftpd'", :acceptable_exit_codes => [0])
      end
    end
  end
end
