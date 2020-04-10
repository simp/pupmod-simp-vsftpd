require 'spec_helper_acceptance'

test_name 'vsftpd class'

hosts_with_role(hosts, 'server').each do |server|
  describe "with server '#{server}'" do
    let(:manifest) { 'include vsftpd' }

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
        on(server, %q{ss -plant | grep ':21 .*vsftpd'})
      end
    end
  end
end
