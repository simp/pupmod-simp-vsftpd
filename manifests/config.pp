# This class provides a method for setting up the main body of
# /etc/vsftpd/vsftpd.conf.
#
# @param pki
#   * If 'simp', include SIMP's pki module and use pki::copy to manage
#     application certs in /etc/pki/simp_apps/vsftpd/pki
#   * If true, do *not* include SIMP's pki module, but still use pki::copy
#     to manage certs in /etc/pki/simp_apps/vsftpd/pki
#   * If false, do not include SIMP's pki module and do not use pki::copy
#     to manage certs.  You will need to appropriately assign a subset of:
#     * app_pki_dir
#     * app_pki_key
#     * app_pki_cert
#     * app_pki_ca
#     * app_pki_ca_dir
#
# @param app_pki_external_source
#   * If pki = 'simp' or true, this is the directory from which certs will be
#     copied, via pki::copy.  Defaults to /etc/pki/simp.
#
#   * If pki = false, this variable has no effect.
#
# @param app_pki_dir
#   This variable controls the basepath of $app_pki_key, $app_pki_cert,
#   $app_pki_ca, $app_pki_ca_dir, and $app_pki_crl.
#   It defaults to /etc/pki/simp_apps/vsftpd/pki.
#
# @param app_pki_key
#   Path and name of the private SSL key file
#
# @param app_pki_cert
#   Path and name of the public SSL certificate
#
# @param app_pki_ca
#   Path and name of the CA.
#
# * The rest of the parameters can be found on the vsftpd.conf man page *
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
# @author Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd::config (
  Optional[Boolean]               $allow_anon_ssl           = undef,
  Optional[Boolean]               $anon_mkdir_write_enable  = undef,
  Optional[Boolean]               $anon_other_write_enable  = undef,
  Boolean                         $anon_upload_enable       = true,
  Optional[Boolean]               $anon_world_readable_only = undef,
  Boolean                         $anonymous_enable         = true,
  Optional[Boolean]               $ascii_download_enable    = undef,
  Optional[Boolean]               $ascii_upload_enable      = undef,
  Optional[Boolean]               $async_abor_enable        = undef,
  Optional[Boolean]               $background               = undef,
  Optional[Boolean]               $check_shell              = undef,
  Optional[Boolean]               $chmod_enable             = undef,
  Optional[Boolean]               $chown_uploads            = undef,
  Optional[Boolean]               $chroot_list_enable       = undef,
  Optional[Boolean]               $chroot_local_user        = undef,
  Boolean                         $connect_from_port_20     = true,
  Optional[Boolean]               $deny_email_enable        = undef,
  Optional[Boolean]               $dirlist_enable           = undef,
  Boolean                         $dirmessage_enable        = true,
  Optional[Boolean]               $download_enable          = undef,
  Optional[Boolean]               $dual_log_enable          = undef,
  Optional[Boolean]               $force_dot_files          = undef,
  Optional[Boolean]               $force_anon_data_ssl      = undef,
  Optional[Boolean]               $force_anon_logins_ssl    = undef,
  Boolean                         $force_local_data_ssl     = true,
  Boolean                         $force_local_logins_ssl   = true,
  Optional[Boolean]               $guest_enable             = undef,
  Optional[Boolean]               $hide_ids                 = undef,
  Optional[Boolean]               $listen_ipv6              = undef,
  Optional[Boolean]               $lock_upload_files        = undef,
  Optional[Boolean]               $log_ftp_protocol         = undef,
  Optional[Boolean]               $ls_recurse_enable        = undef,
  Optional[Boolean]               $mdtm_write               = undef,
  Optional[Boolean]               $no_anon_password         = undef,
  Optional[Boolean]               $no_log_lock              = undef,
  Optional[Boolean]               $one_process_model        = undef,
  Optional[Boolean]               $passwd_chroot_enable     = undef,
  Optional[Boolean]               $pasv_addr_resolve        = undef,
  Optional[Boolean]               $pasv_promiscuous         = undef,
  Optional[Boolean]               $port_enable              = undef,
  Optional[Boolean]               $port_promiscuous         = undef,
  Optional[Boolean]               $reverse_lookup_enable    = undef,
  Optional[Boolean]               $run_as_launching_user    = undef,
  Optional[Boolean]               $secure_email_list_enable = undef,
  Optional[Boolean]               $session_support          = undef,
  Optional[Boolean]               $setproctitle_enable      = undef,
  Boolean                         $ssl_sslv2                = false,
  Boolean                         $ssl_sslv3                = false,
  Boolean                         $ssl_tlsv1                = true,
  Boolean                         $syslog_enable            = true,
  Optional[Boolean]               $text_userdb_names        = undef,
  Optional[Boolean]               $tilde_user_enable        = undef,
  Optional[Boolean]               $use_localtime            = undef,
  Optional[Boolean]               $use_sendfile             = undef,
  Stdlib::Absolutepath            $userlist_file            = '/etc/vsftpd/user_list',
  Boolean                         $userlist_log             = true,
  Optional[Boolean]               $virtual_use_local_privs  = undef,
  Boolean                         $write_enable             = true,
  Boolean                         $xferlog_enable           = true,
  Boolean                         $xferlog_std_format       = true,
  Optional[Integer]               $accept_timeout           = undef,
  Optional[Integer]               $anon_max_rate            = undef,
  Optional[Simplib::Umask]        $anon_umask               = undef,
  Optional[Integer]               $connect_timeout          = undef,
  Optional[Integer]               $data_connection_timeout  = undef,
  Optional[Integer]               $delay_failed_login       = undef,
  Optional[Integer]               $delay_successful_login   = undef,
  Optional[Simplib::Umask]        $file_open_mode           = undef,
  Optional[Integer]               $idle_session_timeout     = undef,
  Optional[Integer]               $local_max_rate           = undef,
  Simplib::Umask                  $local_umask              = '022',
  Optional[Integer]               $max_clients              = undef,
  Optional[Integer]               $max_login_fails          = undef,
  Optional[Integer]               $max_per_ip               = undef,
  Optional[Integer]               $trans_chunk_size         = undef,
  Optional[String]                $anon_root                = undef,
  Optional[Stdlib::Absolutepath]  $banned_email_file        = undef,
  Stdlib::Absolutepath            $banner_file              = '/etc/issue.net',
  Optional[String]                $chown_username           = undef,
  Optional[Stdlib::Absolutepath]  $chroot_list_file         = undef,
  Optional[Array[String]]         $cmds_allowed             = undef,
  Optional[String]                $deny_file                = undef, # can contain regex
  Optional[Stdlib::Absolutepath]  $dsa_cert_file            = undef,
  Optional[Stdlib::Absolutepath]  $dsa_private_key_file     = undef,
  Optional[Stdlib::Absolutepath]  $email_password_file      = undef,
  Optional[String]                $hide_file                = undef, # can contain regex
  Optional[String]                $listen_address6          = undef,
  Optional[Stdlib::Absolutepath]  $local_root               = undef,
  Optional[Stdlib::Absolutepath]  $message_file             = undef,
  Optional[String]                $nopriv_user              = undef,
  Optional[String]                $pasv_address             = undef,
  Stdlib::Absolutepath            $app_pki_external_source  = simplib::lookup('simp_options::pki::source', { 'default_value' => '/etc/simp/pki' }),
  Stdlib::Absolutepath            $app_pki_dir              = '/etc/pki/simp_apps/vsftpd/pki',
  Stdlib::Absolutepath            $app_pki_cert             = "${app_pki_dir}/public/${::fqdn}.pub",
  Stdlib::Absolutepath            $app_pki_key              = "${app_pki_dir}/private/${::fqdn}.pem",
  Stdlib::Absolutepath            $app_pki_ca               = "${app_pki_dir}/cacerts/cacerts.pem",
  Boolean                         $validate_cert            = $::vsftpd::validate_cert,
  Optional[Stdlib::Absolutepath]  $secure_chroot_dir        = undef,
  Optional[Stdlib::Absolutepath]  $user_config_dir          = undef,
  Optional[String]                $user_sub_token           = undef,
  Optional[Stdlib::Absolutepath]  $vsftpd_log_file          = undef,
  Optional[Stdlib::Absolutepath]  $xferlog_file             = undef,
  String                          $min_uid                  = '500'
) {
  assert_private()

  if $listen_address6 { validate_net_list($listen_address6) }
  if $pasv_address    { validate_net_list($pasv_address) }

  if ($::vsftpd::listen_ipv4 and $listen_ipv6) {
    fail('$::vsftpd::listen_ipv4 and $::vsftpd::config::listen_ipv6 are mutually exculsive')
  }

  $_tcp_wrappers       = $::vsftpd::tcpwrappers
  $_listen_port        = $::vsftpd::listen_port
  $_listen_address     = $::vsftpd::listen_address
  $_ftp_data_port      = $::vsftpd::ftp_data_port
  $_pasv_enable        = $::vsftpd::pasv_enable
  $_listen_ipv4        = $::vsftpd::listen_ipv4
  $_ipv6_enabled       = $facts['ipv6_enabled']
  $_vsftpd_group       = $::vsftpd::vsftpd_group
  $_ftp_username       = $::vsftpd::vsftpd_user
  $_user_list          = $::vsftpd::user_list
  $_guest_username     = $::vsftpd::vsftpd_user
  $_userlist_deny      = $::vsftpd::userlist_deny
  $_userlist_enable    = $::vsftpd::userlist_enable
  $_pasv_max_port      = $::vsftpd::pasv_max_port
  $_pasv_min_port      = $::vsftpd::pasv_min_port
  $_local_enable       = $::vsftpd::local_enable
  $_pam_service_name   = $::vsftpd::pam_service_name
  $_ssl_enable         = $::vsftpd::ssl_enable
  $_require_ssl_reuse  = $::vsftpd::require_ssl_reuse
  $_ssl_ciphers        = $::vsftpd::cipher_suite

  if $::vsftpd::pki {
    pki::copy { 'vsftpd':
      source => $app_pki_external_source,
      pki    => $::vsftpd::pki,
      group  => $_vsftpd_group,
      notify => Service['vsftpd']
    }
  }

  file { '/etc/vsftpd':
    ensure   => 'directory',
    owner    => 'root',
    group    => $_vsftpd_group,
    mode     => '0640',
    recurse  => true,
    checksum => undef,
    purge    => true,
    require  => Package['vsftpd']
  }

  file { '/etc/vsftpd/ftpusers':
    owner   => 'root',
    group   => $_vsftpd_group,
    mode    => '0640',
    source  => 'puppet:///modules/vsftpd/ftpusers',
    notify  => Service['vsftpd'],
    require => Package['vsftpd']
  }

  file { $userlist_file:
    owner   => 'root',
    group   => $_vsftpd_group,
    mode    => '0640',
    content => template('vsftpd/user_list.erb'),
    notify  => Service['vsftpd'],
    require => Package['vsftpd']
  }

  file { '/etc/pam.d/vsftpd':
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    source  => 'puppet:///modules/vsftpd/vsftpd.pam',
    require => Package['vsftpd']
  }

  file { '/etc/vsftpd/vsftpd.conf':
    owner   => 'root',
    group   => $_vsftpd_group,
    mode    => '0640',
    content => template('vsftpd/vsftpd.conf.erb'),
    notify  => Service['vsftpd']
  }

  if !empty($min_uid) {
    file { '/etc/ftpusers':
      ensure => 'file',
      force  => true,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }
    ftpusers { '/etc/ftpusers':
      min_id  => $min_uid,
      require => File['/etc/ftpusers']
    }
  }
}
