require 'spec_helper'

# really testing 'vsftpd::config', but since private, do this
# via vsftpd
describe 'vsftpd' do
  on_supported_os.each do |os, os_facts|
    let(:facts) do
      os_facts
    end

    context "on #{os}" do
      context 'with default parameters of ::vsftpd::config and ::vsftpd' do
        let(:facts) do
          os_facts.merge(
            ipv6_enabled: false,
          )
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file('/etc/vsftpd').with(
            ensure: 'directory',
            group: 'ftp',
          )
        end
        it { is_expected.to contain_file('/etc/vsftpd/ftpusers').with(group: 'ftp') }
        it {
          is_expected.to contain_file('/etc/vsftpd/user_list').with_content(<<~EOM,
            # vsftpd userlist
            # If userlist_deny=NO, only allow users in this file
            # If userlist_deny=YES (default), never allow users in this file, and
            # do not even prompt for a password.
            # Note that the default vsftpd pam config also checks /etc/vsftpd/ftpusers
            # for users that are denied.
            root
            bin
            daemon
            adm
            lp
            sync
            shutdown
            halt
            mail
            news
            uucp
            operator
            games
            nobody
          EOM
                                                                           )
        }

        it {
          is_expected.to contain_file('/etc/vsftpd/vsftpd.conf').with_content(<<~EOM,
            force_local_data_ssl=YES
            force_local_logins_ssl=YES
            ssl_sslv2=NO
            ssl_sslv3=NO
            ssl_tlsv1=NO
            ssl_tlsv1_1=NO
            ssl_tlsv1_2=YES
            ssl_ciphers=DEFAULT:!MEDIUM
            rsa_cert_file=/etc/pki/simp_apps/vsftpd/x509/public/foo.example.com.pub
            rsa_private_key_file=/etc/pki/simp_apps/vsftpd/x509/private/foo.example.com.pem
            ca_certs_file=/etc/pki/simp_apps/vsftpd/x509/cacerts/cacerts.pem
            validate_cert=YES
            anon_upload_enable=YES
            anonymous_enable=YES
            connect_from_port_20=YES
            dirmessage_enable=YES
            listen=YES
            local_enable=YES
            pasv_enable=YES
            ssl_enable=YES
            require_ssl_reuse=YES
            syslog_enable=YES
            tcp_wrappers=NO
            userlist_deny=YES
            userlist_enable=YES
            userlist_log=YES
            write_enable=YES
            xferlog_enable=YES
            xferlog_std_format=YES
            ftp_data_port=20
            listen_port=21
            local_umask=022
            banner_file=/etc/issue.net
            ftp_username=ftp
            guest_username=ftp
            pam_service_name=vsftpd
            userlist_file=/etc/vsftpd/user_list
          EOM
                                                                             )
        }
      end

      context 'with all vsftpd.conf parameters, ipv4 listen and booleans true' do
        let(:facts) do
          os_facts.merge(
            ipv6_enabled: false,
          )
        end
        let(:hieradata) { 'vsftpd_for_all_conf_params_true' }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('/some/userlist/file').with_content(<<~EOM)
            # vsftpd userlist
            # If userlist_deny=NO, only allow users in this file
            # If userlist_deny=YES (default), never allow users in this file, and
            # do not even prompt for a password.
            # Note that the default vsftpd pam config also checks /etc/vsftpd/ftpusers
            # for users that are denied.
            foo
            bar
            baz
          EOM
        }

        it {
          is_expected.to contain_file('/etc/vsftpd/vsftpd.conf').with_content(<<~EOM,
            allow_anon_ssl=YES
            force_anon_data_ssl=YES
            force_anon_logins_ssl=YES
            force_local_data_ssl=YES
            force_local_logins_ssl=YES
            ssl_sslv2=YES
            ssl_sslv3=YES
            ssl_tlsv1=YES
            ssl_tlsv1_1=YES
            ssl_tlsv1_2=YES
            ssl_ciphers=HIGH
            dsa_cert_file=/some/private/test_dsa.pem
            dsa_private_key_file=/some/private/test.dsa
            rsa_cert_file=/some/public/test.pub
            rsa_private_key_file=/some/private/test.pem
            ca_certs_file=/some/cacerts/cacerts.pem
            validate_cert=YES
            anon_mkdir_write_enable=YES
            anon_other_write_enable=YES
            anon_upload_enable=YES
            anon_world_readable_only=YES
            anonymous_enable=YES
            ascii_download_enable=YES
            ascii_upload_enable=YES
            async_abor_enable=YES
            background=YES
            check_shell=YES
            chmod_enable=YES
            chown_uploads=YES
            chown_username=some_user
            chroot_list_enable=YES
            chroot_local_user=YES
            connect_from_port_20=YES
            deny_email_enable=YES
            dirlist_enable=YES
            dirmessage_enable=YES
            message_file=/some/message/file
            download_enable=YES
            dual_log_enable=YES
            force_dot_files=YES
            guest_enable=YES
            hide_ids=YES
            listen=YES
            local_enable=YES
            lock_upload_files=YES
            log_ftp_protocol=YES
            ls_recurse_enable=YES
            mdtm_write=YES
            no_anon_password=YES
            no_log_lock=YES
            one_process_model=YES
            passwd_chroot_enable=YES
            pasv_addr_resolve=YES
            pasv_enable=YES
            pasv_promiscuous=YES
            port_enable=YES
            port_promiscuous=YES
            reverse_lookup_enable=YES
            run_as_launching_user=YES
            secure_email_list_enable=YES
            session_support=YES
            setproctitle_enable=YES
            ssl_enable=YES
            require_ssl_reuse=YES
            syslog_enable=YES
            tcp_wrappers=YES
            text_userdb_names=YES
            tilde_user_enable=YES
            use_localtime=YES
            use_sendfile=YES
            userlist_deny=YES
            userlist_enable=YES
            userlist_log=YES
            virtual_use_local_privs=YES
            write_enable=YES
            xferlog_enable=YES
            xferlog_std_format=YES
            accept_timeout=1
            anon_max_rate=2
            anon_umask=070
            connect_timeout=3
            data_connection_timeout=4
            delay_failed_login=5
            delay_successful_login=6
            file_open_mode=0644
            ftp_data_port=7
            idle_session_timeout=8
            listen_port=9
            local_max_rate=10
            local_umask=002
            max_clients=11
            max_login_fails=12
            max_per_ip=13
            pasv_max_port=15
            pasv_min_port=14
            trans_chunk_size=16
            anon_root=/some/dir
            banned_email_file=/some/banned/email/file
            banner_file=/some/banner/file
            chroot_list_file=/some/chroot/list/file
            cmds_allowed=PASV,RETR,QUIT
            deny_file={*.mp3,*.mov,.private}
            email_password_file=/some/email/password/file
            ftp_username=some_username
            guest_username=some_username
            hide_file={*.mp3,.hidden,hide*,h?}
            listen_address=1.2.3.4
            listen_address6=2001:0db8:85a3:0000:0000:8a2e:0370:7334
            local_root=/some/local/root/dir
            nopriv_user=priv_user
            pam_service_name=pam_service_name
            pasv_address=2.3.4.5
            secure_chroot_dir=/some/secure/chroot/dir
            user_config_dir=/some/user/config/dir
            user_sub_token=$USER
            userlist_file=/some/userlist/file
            vsftpd_log_file=/some/vsftpd/log/file
            xferlog_file=/some/xfer/log/file
          EOM
                                                                             )
        }
      end

      context 'with ssl enabled, ipv6 listen and booleans false' do
        let(:facts) do
          os_facts.merge(
            ipv6_enabled: true,
          )
        end
        let(:hieradata) { 'vsftpd_for_conf_params_false' }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('/etc/vsftpd/vsftpd.conf').with_content(<<~EOM)
            allow_anon_ssl=NO
            force_anon_data_ssl=NO
            force_anon_logins_ssl=NO
            force_local_data_ssl=NO
            force_local_logins_ssl=NO
            ssl_sslv2=NO
            ssl_sslv3=NO
            ssl_tlsv1=NO
            ssl_tlsv1_1=NO
            ssl_tlsv1_2=NO
            ssl_ciphers=HIGH
            rsa_cert_file=/some/public/test.pub
            rsa_private_key_file=/some/private/test.pem
            ca_certs_file=/some/cacerts/cacerts.pem
            validate_cert=NO
            anon_mkdir_write_enable=NO
            anon_other_write_enable=NO
            anon_upload_enable=NO
            anon_world_readable_only=NO
            anonymous_enable=NO
            ascii_download_enable=NO
            ascii_upload_enable=NO
            async_abor_enable=NO
            background=NO
            check_shell=NO
            chmod_enable=NO
            chown_uploads=NO
            chroot_list_enable=NO
            chroot_local_user=NO
            connect_from_port_20=NO
            deny_email_enable=NO
            dirlist_enable=NO
            dirmessage_enable=NO
            download_enable=NO
            dual_log_enable=NO
            force_dot_files=NO
            guest_enable=NO
            hide_ids=NO
            listen_ipv6=YES
            local_enable=NO
            lock_upload_files=NO
            log_ftp_protocol=NO
            ls_recurse_enable=NO
            mdtm_write=NO
            no_anon_password=NO
            no_log_lock=NO
            one_process_model=NO
            passwd_chroot_enable=NO
            pasv_addr_resolve=NO
            pasv_enable=NO
            pasv_promiscuous=NO
            port_enable=NO
            port_promiscuous=NO
            reverse_lookup_enable=NO
            run_as_launching_user=NO
            secure_email_list_enable=NO
            session_support=NO
            setproctitle_enable=NO
            ssl_enable=YES
            require_ssl_reuse=NO
            syslog_enable=NO
            tcp_wrappers=NO
            text_userdb_names=NO
            tilde_user_enable=NO
            use_localtime=NO
            use_sendfile=NO
            userlist_deny=NO
            userlist_enable=NO
            userlist_log=NO
            virtual_use_local_privs=NO
            write_enable=NO
            xferlog_enable=NO
            xferlog_std_format=NO
            ftp_data_port=7
            listen_port=9
            local_umask=022
            pasv_max_port=15
            pasv_min_port=14
            banner_file=/etc/issue.net
            ftp_username=some_username
            guest_username=some_username
            listen_address=1.2.3.4
            pam_service_name=pam_service_name
            userlist_file=/etc/vsftpd/user_list
          EOM
        }
      end

      context 'with ipv4 and ipv6 listen' do
        let(:facts) do
          os_facts.merge(
            ipv6_enabled: true,
          )
        end
        let(:hieradata) { 'vsftpd_with_both_ipv4_and_ipv6_listen' }

        it { is_expected.not_to compile.with_all_deps }
      end
    end
  end
end
