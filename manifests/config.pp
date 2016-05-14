#
# == Class vsftpd::config
#
# This class provides a method for setting up the main body of
# /etc/vsftpd/vsftpd.conf.
#
# == Parameters
#
# [*rsa_cert_file*]
#   If you change this from the default, you will need to ensure that you
#   manage the file and that vsftpd restarts when the file is updated.
#
# [*rsa_private_key_file*]
#   If you change this from the default, you will need to ensure that you
#   manage the file and that vsftpd restarts when the file is updated.
#
# * The rest of the parmeters can be found on the vsftpd.conf man page *
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd::config (
  $allow_anon_ssl           = undef,
  $anon_mkdir_write_enable  = undef,
  $anon_other_write_enable  = undef,
  $anon_upload_enable       = true,
  $anon_world_readable_only = undef,
  $anonymous_enable         = true,
  $ascii_download_enable    = undef,
  $ascii_upload_enable      = undef,
  $async_abor_enable        = undef,
  $background               = undef,
  $check_shell              = undef,
  $chmod_enable             = undef,
  $chown_uploads            = undef,
  $chroot_list_enable       = undef,
  $chroot_local_user        = undef,
  $connect_from_port_20     = true,
  $deny_email_enable        = undef,
  $dirlist_enable           = undef,
  $dirmessage_enable        = true,
  $download_enable          = undef,
  $dual_log_enable          = undef,
  $force_dot_files          = undef,
  $force_anon_data_ssl      = undef,
  $force_anon_logins_ssl    = undef,
  $force_local_data_ssl     = true,
  $force_local_logins_ssl   = true,
  $guest_enable             = undef,
  $hide_ids                 = undef,
  $listen_ipv6              = undef,
  $lock_upload_files        = undef,
  $log_ftp_protocol         = undef,
  $ls_recurse_enable        = undef,
  $mdtm_write               = undef,
  $no_anon_password         = undef,
  $no_log_lock              = undef,
  $one_process_model        = undef,
  $passwd_chroot_enable     = undef,
  $pasv_addr_resolve        = undef,
  $pasv_promiscuous         = undef,
  $port_enable              = undef,
  $port_promiscuous         = undef,
  $reverse_lookup_enable    = undef,
  $run_as_launching_user    = undef,
  $secure_email_list_enable = undef,
  $session_support          = undef,
  $setproctitle_enable      = undef,
  $ssl_sslv2                = false,
  $ssl_sslv3                = false,
  $ssl_tlsv1                = true,
  $syslog_enable            = true,
  $text_userdb_names        = undef,
  $tilde_user_enable        = undef,
  $use_localtime            = undef,
  $use_sendfile             = undef,
  $userlist_log             = true,
  $virtual_use_local_privs  = undef,
  $write_enable             = true,
  $xferlog_enable           = true,
  $xferlog_std_format       = true,
  $accept_timeout           = undef,
  $anon_max_rate            = undef,
  $anon_umask               = undef,
  $connect_timeout          = undef,
  $data_connection_timeout  = undef,
  $delay_failed_login       = undef,
  $delay_successful_login   = undef,
  $file_open_mode           = undef,
  $idle_session_timeout     = undef,
  $local_max_rate           = undef,
  $local_umask              = '022',
  $max_clients              = undef,
  $max_login_fails          = undef,
  $max_per_ip               = undef,
  $trans_chunk_size         = undef,
  $anon_root                = undef,
  $banned_email_file        = undef,
  $banner_file              = '/etc/issue.net',
  $chown_username           = undef,
  $chroot_list_file         = undef,
  $cmds_allowed             = undef,
  $deny_file                = undef,
  $dsa_cert_file            = undef,
  $dsa_private_key_file     = undef,
  $email_password_file      = undef,
  $hide_file                = undef,
  $listen_address6          = undef,
  $local_root               = undef,
  $message_file             = undef,
  $nopriv_user              = undef,
  $pasv_address             = undef,
  $rsa_cert_file            = "${::vsftpd::pki_certs_dir}/pki/public/${::fqdn}.pub",
  $rsa_private_key_file     = "${::vsftpd::pki_certs_dir}/pki/private/${::fqdn}.pem",
  $ca_certs_file            = "${::vsftpd::pki_certs_dir}/pki/cacerts/cacerts.pem",
  $validate_cert            = $::vsftpd::validate_cert,
  $secure_chroot_dir        = undef,
  $ssl_ciphers              = ['HIGH'],
  $user_config_dir          = undef,
  $user_sub_token           = undef,
  $vsftpd_log_file          = undef,
  $xferlog_file             = undef,
) {
  include '::vsftpd'

  if $allow_anon_ssl { validate_bool($allow_anon_ssl) }
  if $anon_mkdir_write_enable { validate_bool($anon_mkdir_write_enable) }
  if $anon_other_write_enable { validate_bool($anon_other_write_enable) }
  if $anon_upload_enable { validate_bool($anon_upload_enable) }
  if $anon_world_readable_only { validate_bool($anon_world_readable_only) }
  if $anonymous_enable { validate_bool($anonymous_enable) }
  if $ascii_download_enable { validate_bool($ascii_download_enable) }
  if $ascii_upload_enable { validate_bool($ascii_upload_enable) }
  if $async_abor_enable { validate_bool($async_abor_enable) }
  if $background { validate_bool($background ) }
  if $check_shell { validate_bool($check_shell) }
  if $chmod_enable { validate_bool($chmod_enable) }
  if $chown_uploads { validate_bool($chown_uploads) }
  if $chroot_list_enable { validate_bool($chroot_list_enable ) }
  if $chroot_local_user { validate_bool($chroot_local_user) }
  if $connect_from_port_20 { validate_bool($connect_from_port_20) }
  if $deny_email_enable { validate_bool($deny_email_enable) }
  if $dirlist_enable { validate_bool($dirlist_enable) }
  if $dirmessage_enable { validate_bool($dirmessage_enable) }
  if $download_enable { validate_bool($download_enable) }
  if $dual_log_enable { validate_bool($dual_log_enable) }
  if $force_dot_files { validate_bool($force_dot_files) }
  if $force_anon_data_ssl { validate_bool($force_anon_data_ssl) }
  if $force_anon_logins_ssl { validate_bool($force_anon_logins_ssl) }
  if $force_local_data_ssl { validate_bool($force_local_data_ssl) }
  if $force_local_logins_ssl { validate_bool($force_local_logins_ssl) }
  if $guest_enable { validate_bool($guest_enable) }
  if $hide_ids { validate_bool($hide_ids) }
  if $listen_ipv6 { validate_bool($listen_ipv6) }
  if $lock_upload_files { validate_bool($lock_upload_files) }
  if $log_ftp_protocol { validate_bool($log_ftp_protocol) }
  if $ls_recurse_enable { validate_bool($ls_recurse_enable) }
  if $mdtm_write { validate_bool($mdtm_write) }
  if $no_anon_password { validate_bool($no_anon_password) }
  if $no_log_lock { validate_bool($no_log_lock) }
  if $one_process_model { validate_bool($one_process_model) }
  if $passwd_chroot_enable { validate_bool($passwd_chroot_enable) }
  if $pasv_addr_resolve { validate_bool($pasv_addr_resolve) }
  if $pasv_promiscuous { validate_bool($pasv_promiscuous) }
  if $port_enable { validate_bool($port_enable) }
  if $port_promiscuous { validate_bool($port_promiscuous) }
  if $reverse_lookup_enable { validate_bool($reverse_lookup_enable) }
  if $run_as_launching_user { validate_bool($run_as_launching_user) }
  if $secure_email_list_enable { validate_bool($secure_email_list_enable) }
  if $session_support { validate_bool($session_support) }
  if $setproctitle_enable { validate_bool($setproctitle_enable) }
  if $ssl_sslv2 { validate_bool($ssl_sslv2) }
  if $ssl_sslv3 { validate_bool($ssl_sslv3) }
  if $ssl_tlsv1 { validate_bool($ssl_tlsv1) }
  if $syslog_enable { validate_bool($syslog_enable ) }
  if $text_userdb_names { validate_bool($text_userdb_names) }
  if $tilde_user_enable { validate_bool($tilde_user_enable ) }
  if $use_localtime { validate_bool($use_localtime) }
  if $use_sendfile { validate_bool($use_sendfile ) }
  if $userlist_log { validate_bool($userlist_log) }
  if $virtual_use_local_privs { validate_bool($virtual_use_local_privs) }
  if $write_enable { validate_bool($write_enable) }
  if $xferlog_enable { validate_bool($xferlog_enable) }
  if $xferlog_std_format { validate_bool($xferlog_std_format) }
  if $accept_timeout { validate_integer($accept_timeout) }
  if $anon_max_rate { validate_integer($anon_max_rate) }
  if $anon_umask { validate_umask($anon_umask) }
  if $connect_timeout { validate_integer($connect_timeout) }
  if $data_connection_timeout { validate_integer($data_connection_timeout) }
  if $delay_failed_login { validate_integer($delay_failed_login) }
  if $delay_successful_login { validate_integer($delay_successful_login) }
  if $file_open_mode { validate_integer($file_open_mode) }
  if $idle_session_timeout { validate_integer($idle_session_timeout) }
  if $local_max_rate { validate_integer($local_max_rate) }
  if $local_umask { validate_umask($local_umask) }
  if $max_clients { validate_integer($max_clients) }
  if $max_login_fails { validate_integer($max_login_fails) }
  if $max_per_ip { validate_integer($max_per_ip) }
  if $trans_chunk_size { validate_integer($trans_chunk_size) }
  if $ssl_ciphers { validate_array($ssl_ciphers) }
  if $user_config_dir  { validate_absolute_path($user_config_dir) }
  if $user_sub_token { validate_string($user_sub_token) }
  if $vsftpd_log_file { validate_absolute_path($vsftpd_log_file) }
  if $xferlog_file { validate_absolute_path($xferlog_file) }
  validate_absolute_path($ca_certs_file)

  compliance_map()

  $_tcp_wrappers       = $::vsftpd::tcp_wrappers
  $_listen_port        = $::vsftpd::listen_port
  $_listen_address     = $::vsftpd::listen_address
  $_ftp_data_port      = $::vsftpd::ftp_data_port
  $_pasv_enable        = $::vsftpd::pasv_enable
  $_listen_ipv4        = $::vsftpd::listen_ipv4
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
  $_ssl_ciphers        = $::vsftpd::_enable_fips ? { true => ['FIPS'], default => $ssl_ciphers }
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

  file { '/etc/vsftpd/user_list':
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
