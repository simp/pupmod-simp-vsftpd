require 'spec_helper_acceptance'

test_name 'vsftpd class'

hosts_with_role(hosts, 'server').each do |server|
  describe "with server '#{server}'" do
    # Exercise noop from a clean (uninstalled) state: on a fresh node the Sicura
    # console previews the module with `puppet apply --noop`, which must not error
    # even though nothing vsftpd manages exists yet. Real idempotence is covered
    # by the applies below. A post-convergence noop check is deliberately omitted:
    # `puppet apply --noop --detailed-exitcodes` always exits 0, so it could never
    # fail and would test nothing.
    context 'in noop mode from a clean state' do
      # Setup, not an assertion: as before(:context) a failure errors this context
      # rather than aborting the whole suite under .rspec's --fail-fast. `puppet
      # resource` exits 0 whether it removes the package or finds it already absent
      # (no --detailed-exitcodes), so no acceptable_exit_codes override is needed.
      before(:context) do
        on(server, 'puppet resource package vsftpd ensure=absent')
      end

      it 'applies without errors in noop mode' do
        apply_manifest_on(server, manifest, catch_failures: true, noop: true)
      end

      # Proof noop engaged nothing: the acceptance nodeset is EL, so rpm -q exits 1
      # when vsftpd is absent; beaker raises on any other exit code.
      it 'does not install the vsftpd package' do
        on(server, 'rpm -q vsftpd', acceptable_exit_codes: [1])
      end
    end

    let(:manifest) { 'include vsftpd' }

    let(:hieradata) do
      <<~EOS
        simp_options::pki: true
        simp_options::pki::source: '/etc/pki/simp-testing/pki'
      EOS
    end

    context 'default parameters with SIMP pki' do
      it 'works with no errors' do
        set_hieradata_on(server, hieradata)
        apply_manifest_on(server, manifest, catch_failures: true)
        # /etc/ftpusers has a permission and context change
        apply_manifest_on(server, manifest, catch_failures: true)
      end

      it 'is idempotent' do
        apply_manifest_on(server, manifest, { catch_changes: true })
      end

      it 'has vsftpd package installed' do
        expect(check_for_package(server, 'vsftpd')).to eq true
      end

      it 'has vsftpd service enabled and running' do
        result = on(server, 'puppet resource service vsftpd')
        expect(result.stdout).to match(%r{ensure\s+=>\s+'running'})
        expect(result.stdout).to match(%r{enable\s+=>\s+'true'})
      end

      it 'is listening on port 21' do
        on(server, "ss -plant | grep ':21 .*vsftpd'")
      end
    end
  end
end
