#
# == Class vsftpd::conf
#
# This class provides a method for setting up the main body of
# /etc/vsftpd/vsftpd.conf.
#
# == Parameters
#
# The parmeters can be found on the vsftpd.conf man page
#
# [*rsa_cert_file*]
#   If you change this from the default, you will need to ensure that you
#   manage the file and that vsftpd restarts when the file is updated.
#
# [*rsa_private_key_file*]
#   If you change this from the default, you will need to ensure that you
#   manage the file and that vsftpd restarts when the file is updated.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd::config (
  $vsftpd_user              = $vsftpd::params::vsftpd_user,
  $vsftpd_group             = $vsftpd::params::vsftpd_group,
  $allow_anon_ssl           = '',
  $anon_mkdir_write_enable  = '',
  $anon_other_write_enable  = '',
  $anon_upload_enable       = true,
  $anon_world_readable_only = '',
  $anonymous_enable         = true,
  $ascii_download_enable    = '',
  $ascii_upload_enable      = '',
  $async_abor_enable        = '',
  $background               = '',
  $check_shell              = '',
  $chmod_enable             = '',
  $chown_uploads            = '',
  $chroot_list_enable       = '',
  $chroot_local_user        = '',
  $connect_from_port_20     = true,
  $deny_email_enable        = '',
  $dirlist_enable           = '',
  $dirmessage_enable        = true,
  $download_enable          = '',
  $dual_log_enable          = '',
  $force_dot_files          = '',
  $force_anon_data_ssl      = '',
  $force_anon_logins_ssl    = '',
  $force_local_data_ssl     = true,
  $force_local_logins_ssl   = true,
  $guest_enable             = '',
  $hide_ids                 = '',
  $listen_ipv4              = $vsftpd::params::listen_ipv4,
  $listen_ipv6              = '',
  $local_enable             = true,
  $lock_upload_files        = '',
  $log_ftp_protocol         = '',
  $ls_recurse_enable        = '',
  $mdtm_write               = '',
  $no_anon_password         = '',
  $no_log_lock              = '',
  $one_process_model        = '',
  $passwd_chroot_enable     = '',
  $pasv_addr_resolve        = '',
  $pasv_enable              = $vsftpd::params::pasv_enable,
  $pasv_promiscuous         = '',
  $port_enable              = '',
  $port_promiscuous         = '',
  $reverse_lookup_enable    = '',
  $run_as_launching_user    = '',
  $secure_email_list_enable = '',
  $session_support          = '',
  $setproctitle_enable      = '',
  $ssl_enable               = true,
  $ssl_sslv2                = false,
  $ssl_sslv3                = false,
  $ssl_tlsv1                = true,
  $syslog_enable            = true,
  $tcp_wrappers             = $vsftpd::params::tcp_wrappers,
  $text_userdb_names        = '',
  $tilde_user_enable        = '',
  $use_localtime            = '',
  $use_sendfile             = '',
  $userlist_deny            = '',
  $userlist_enable          = true,
  $userlist_log             = true,
  $virtual_use_local_privs  = '',
  $write_enable             = true,
  $xferlog_enable           = true,
  $xferlog_std_format       = true,
  $accept_timeout           = '',
  $anon_max_rate            = '',
  $anon_umask               = '',
  $connect_timeout          = '',
  $data_connection_timeout  = '',
  $delay_failed_login       = '',
  $delay_successful_login   = '',
  $file_open_mode           = '',
  $ftp_data_port            = $vsftpd::params::ftp_data_port,
  $idle_session_timeout     = '',
  $listen_port              = $vsftpd::params::listen_port,
  $local_max_rate           = '',
  $local_umask              = '022',
  $max_clients              = '',
  $max_login_fails          = '',
  $max_per_ip               = '',
  $pasv_max_port            = '',
  $pasv_min_port            = '',
  $trans_chunk_size         = '',
  $anon_root                = '',
  $banned_email_file        = '',
  $banner_file              = '/etc/issue.net',
  $chown_username           = '',
  $chroot_list_file         = '',
  $cmds_allowed             = '',
  $deny_file                = '',
  $dsa_cert_file            = '',
  $dsa_private_key_file     = '',
  $email_password_file      = '',
  $ftp_username             = $vsftpd_user,
  $guest_username           = $vsftpd_user,
  $hide_file                = '',
  $listen_address           = '',
  $listen_address6          = '',
  $local_root               = '',
  $message_file             = '',
  $nopriv_user              = '',
  $pam_service_name         = versioncmp(simp_version(),'5') ? { '-1' => 'vsftpd', default => 'ftp'},
  $pasv_address             = '',
  $rsa_cert_file            = "/etc/vsftpd/pki/public/${::fqdn}.pub",
  $rsa_private_key_file     = "/etc/vsftpd/pki/private/${::fqdn}.pem",
  $secure_chroot_dir        = '',
  $ssl_ciphers              = ['HIGH'],
  $user_config_dir          = '',
  $user_sub_token           = '',
  $userlist_file            = '',
  $vsftpd_log_file          = '',
  $xferlog_file             = '',
  $allowed_nets             = $vsftpd::params::allowed_nets,
) inherits vsftpd::params {
  include '::vsftpd'

  file { '/etc/vsftpd':
    ensure   => 'directory',
    owner    => 'root',
    group    => $vsftpd_group,
    mode     => '0640',
    recurse  => true,
    checksum => undef,
    purge    => true,
    require  => Package['vsftpd']
  }

  file { '/etc/vsftpd/ftpusers':
    owner   => 'root',
    group   => $vsftpd_group,
    mode    => '0640',
    source  => 'puppet:///modules/vsftpd/ftpusers',
    notify  => Service['vsftpd'],
    require => Package['vsftpd']
  }

  file { '/etc/vsftpd/user_list':
    owner   => 'root',
    group   => $vsftpd_group,
    mode    => '0640',
    source  => 'puppet:///modules/vsftpd/user_list',
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
    group   => $vsftpd_group,
    mode    => '0640',
    content => template('vsftpd/vsftpd.conf.erb'),
    notify  => Service['vsftpd']
  }

  validate_string($vsftpd_user)
  validate_string($vsftpd_group)
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
  if $listen_ipv4 { validate_bool($listen_ipv4) }
  if $listen_ipv6 { validate_bool($listen_ipv6) }
  if $local_enable { validate_bool($local_enable) }
  if $lock_upload_files { validate_bool($lock_upload_files) }
  if $log_ftp_protocol { validate_bool($log_ftp_protocol) }
  if $ls_recurse_enable { validate_bool($ls_recurse_enable) }
  if $mdtm_write { validate_bool($mdtm_write) }
  if $no_anon_password { validate_bool($no_anon_password) }
  if $no_log_lock { validate_bool($no_log_lock) }
  if $one_process_model { validate_bool($one_process_model) }
  if $passwd_chroot_enable { validate_bool($passwd_chroot_enable) }
  if $pasv_addr_resolve { validate_bool($pasv_addr_resolve) }
  if $pasv_enable { validate_bool($pasv_enable) }
  if $pasv_promiscuous { validate_bool($pasv_promiscuous) }
  if $port_enable { validate_bool($port_enable) }
  if $port_promiscuous { validate_bool($port_promiscuous) }
  if $reverse_lookup_enable { validate_bool($reverse_lookup_enable) }
  if $run_as_launching_user { validate_bool($run_as_launching_user) }
  if $secure_email_list_enable { validate_bool($secure_email_list_enable) }
  if $session_support { validate_bool($session_support) }
  if $setproctitle_enable { validate_bool($setproctitle_enable) }
  if $ssl_enable { validate_bool($ssl_enable) }
  if $ssl_sslv2 { validate_bool($ssl_sslv2) }
  if $ssl_sslv3 { validate_bool($ssl_sslv3) }
  if $ssl_tlsv1 { validate_bool($ssl_tlsv1) }
  if $syslog_enable { validate_bool($syslog_enable ) }
  if $tcp_wrappers { validate_bool($tcp_wrappers) }
  if $text_userdb_names { validate_bool($text_userdb_names) }
  if $tilde_user_enable { validate_bool($tilde_user_enable ) }
  if $use_localtime { validate_bool($use_localtime) }
  if $use_sendfile { validate_bool($use_sendfile ) }
  if $userlist_deny { validate_bool($userlist_deny) }
  if $userlist_enable { validate_bool($userlist_enable) }
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
  if $ftp_data_port { validate_integer($ftp_data_port ) }
  if $idle_session_timeout { validate_integer($idle_session_timeout) }
  if $listen_port { validate_integer($listen_port) }
  if $local_max_rate { validate_integer($local_max_rate) }
  if $local_umask { validate_umask($local_umask) }
  if $max_clients { validate_integer($max_clients) }
  if $max_login_fails { validate_integer($max_login_fails) }
  if $max_per_ip { validate_integer($max_per_ip) }
  if $pasv_max_port { validate_integer($pasv_max_port) }
  if $pasv_min_port { validate_integer($pasv_min_port) }
  if $trans_chunk_size { validate_integer($trans_chunk_size) }
  if $ssl_ciphers { validate_array($ssl_ciphers) }
}
