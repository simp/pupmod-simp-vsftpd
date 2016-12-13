#
# == Class vsftpd::config
#
# This class provides a method for setting up the main body of
# /etc/vsftpd/vsftpd.conf.
#
# == Parameters
#
# [*app_pki_cert*]
#   Corresponds to rsa_cert_file in vsftpd.conf.
#   If you change this from the default, you will need to ensure that you
#   manage the file and that vsftpd restarts when the file is updated.
#
# [*app_pki_key*]
#   Corresponds to rsa_private_key_file in vsftpd.conf.
#   If you change this from the default, you will need to ensure that you
#   manage the file and that vsftpd restarts when the file is updated.
#
# [*app_pki_ca*]
#   Corresponds to ca_certs_file in vsftpd.conf.
#   If you change this from the default, you will need to ensure that you
#   manage the file and that vsftpd restarts when the file is updated.
#
#
# * The rest of the parameters can be found on the vsftpd.conf man page *
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd::config (
  Optional[Boolean] $allow_anon_ssl                          = undef,
  Optional[Boolean] $anon_mkdir_write_enable                 = undef,
  Optional[Boolean] $anon_other_write_enable                 = undef,
  Boolean $anon_upload_enable                                = true,
  Optional[Boolean] $anon_world_readable_only                = undef,
  Boolean $anonymous_enable                                  = true,
  Optional[Boolean] $ascii_download_enable                   = undef,
  Optional[Boolean] $ascii_upload_enable                     = undef,
  Optional[Boolean] $async_abor_enable                       = undef,
  Optional[Boolean] $background                              = undef,
  Optional[Boolean] $check_shell                             = undef,
  Optional[Boolean] $chmod_enable                            = undef,
  Optional[Boolean] $chown_uploads                           = undef,
  Optional[Boolean] $chroot_list_enable                      = undef,
  Optional[Boolean] $chroot_local_user                       = undef,
  Boolean $connect_from_port_20                              = true,
  Optional[Boolean] $deny_email_enable                       = undef,
  Optional[Boolean] $dirlist_enable                          = undef,
  Boolean $dirmessage_enable                                 = true,
  Optional[Boolean] $download_enable                         = undef,
  Optional[Boolean] $dual_log_enable                         = undef,
  Optional[Boolean] $force_dot_files                         = undef,
  Optional[Boolean] $force_anon_data_ssl                     = undef,
  Optional[Boolean] $force_anon_logins_ssl                   = undef,
  Boolean $force_local_data_ssl                              = true,
  Boolean $force_local_logins_ssl                            = true,
  Optional[Boolean] $guest_enable                            = undef,
  Optional[Boolean] $hide_ids                                = undef,
  Optional[Boolean] $listen_ipv6                             = undef,
  Optional[Boolean] $lock_upload_files                       = undef,
  Optional[Boolean] $log_ftp_protocol                        = undef,
  Optional[Boolean] $ls_recurse_enable                       = undef,
  Optional[Boolean] $mdtm_write                              = undef,
  Optional[Boolean] $no_anon_password                        = undef,
  Optional[Boolean] $no_log_lock                             = undef,
  Optional[Boolean] $one_process_model                       = undef,
  Optional[Boolean] $passwd_chroot_enable                    = undef,
  Optional[Boolean] $pasv_addr_resolve                       = undef,
  Optional[Boolean] $pasv_promiscuous                        = undef,
  Optional[Boolean] $port_enable                             = undef,
  Optional[Boolean] $port_promiscuous                        = undef,
  Optional[Boolean] $reverse_lookup_enable                   = undef,
  Optional[Boolean] $run_as_launching_user                   = undef,
  Optional[Boolean] $secure_email_list_enable                = undef,
  Optional[Boolean] $session_support                         = undef,
  Optional[Boolean] $setproctitle_enable                     = undef,
  Boolean $ssl_sslv2                                         = false,
  Boolean $ssl_sslv3                                         = false,
  Boolean $ssl_tlsv1                                         = true,
  Boolean $syslog_enable                                     = true,
  Optional[Boolean] $text_userdb_names                       = undef,
  Optional[Boolean] $tilde_user_enable                       = undef,
  Optional[Boolean] $use_localtime                           = undef,
  Optional[Boolean] $use_sendfile                            = undef,
  Stdlib::Absolutepath $userlist_file                        = '/etc/vsftpd/user_list',
  Boolean $userlist_log                                      = true,
  Optional[Boolean] $virtual_use_local_privs                 = undef,
  Boolean $write_enable                                      = true,
  Boolean $xferlog_enable                                    = true,
  Boolean $xferlog_std_format                                = true,
  Optional[Stdlib::Compat::Integer] $accept_timeout          = undef,
  Optional[Stdlib::Compat::Integer] $anon_max_rate           = undef,
  Optional[String]                  $anon_umask              = undef,
  Optional[Stdlib::Compat::Integer] $connect_timeout         = undef,
  Optional[Stdlib::Compat::Integer] $data_connection_timeout = undef,
  Optional[Stdlib::Compat::Integer] $delay_failed_login      = undef,
  Optional[Stdlib::Compat::Integer] $delay_successful_login  = undef,
  Optional[String] $file_open_mode                           = undef,
  Optional[Stdlib::Compat::Integer] $idle_session_timeout    = undef,
  Optional[Stdlib::Compat::Integer] $local_max_rate          = undef,
  String $local_umask                                        = '022',
  Optional[Stdlib::Compat::Integer] $max_clients             = undef,
  Optional[Stdlib::Compat::Integer] $max_login_fails         = undef,
  Optional[Stdlib::Compat::Integer] $max_per_ip              = undef,
  Optional[Stdlib::Compat::Integer] $trans_chunk_size        = undef,
  Optional[String] $anon_root                                = undef,
  Optional[Stdlib::Absolutepath] $banned_email_file          = undef,
  Stdlib::Absolutepath $banner_file                          = '/etc/issue.net',
  Optional[String] $chown_username                           = undef,
  Optional[Stdlib::Absolutepath] $chroot_list_file           = undef,
  Optional[Array[String]] $cmds_allowed                      = undef,
  Optional[String] $deny_file                                = undef, # can contain regex
  Optional[Stdlib::Absolutepath] $dsa_cert_file              = undef,
  Optional[Stdlib::Absolutepath] $dsa_private_key_file       = undef,
  Optional[Stdlib::Absolutepath]  $email_password_file       = undef,
  Optional[String] $hide_file                                = undef, # can contain regex
  Optional[String] $listen_address6                          = undef,
  Optional[Stdlib::Absolutepath] $local_root                 = undef,
  Optional[Stdlib::Absolutepath] $message_file               = undef,
  Optional[String] $nopriv_user                              = undef,
  Optional[String] $pasv_address                             = undef,
  Stdlib::Absolutepath $app_pki_cert                         = "${::vsftpd::app_pki_dir}/pki/public/${::fqdn}.pub",
  Stdlib::Absolutepath $app_pki_key                          = "${::vsftpd::app_pki_dir}/pki/private/${::fqdn}.pem",
  Stdlib::Absolutepath $app_pki_ca                           = "${::vsftpd::app_pki_dir}/pki/cacerts/cacerts.pem",
  Boolean $validate_cert                                     = $::vsftpd::validate_cert,
  Optional[Stdlib::Absolutepath] $secure_chroot_dir          = undef,
  Optional[Stdlib::Absolutepath] $user_config_dir            = undef,
  Optional[String] $user_sub_token                           = undef,
  Optional[Stdlib::Absolutepath] $vsftpd_log_file            = undef,
  Optional[Stdlib::Absolutepath] $xferlog_file               = undef,
) {
  assert_private()

  if $anon_umask { validate_umask($anon_umask) }
  if $file_open_mode { validate_umask($file_open_mode) }
  if $local_umask { validate_umask($local_umask) }
  if $listen_address6 { validate_net_list($listen_address6) }
  if $pasv_address { validate_net_list($pasv_address) }
  #TODO Validate content of $cmds_allowed, which is a list of FTP commands

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

}
