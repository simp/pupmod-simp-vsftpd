# This class provides a method for setting up the main body of
# /etc/vsftpd/vsftpd.conf.
#
# @param app_pki_external_source
#   * If pki = 'simp' or true, this is the directory from which certs will be
#     copied, via pki::copy.  Defaults to /etc/pki/simp/x509.
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
# @param allow_anon_ssl
#   If true, anonymous users are permitted to use SSL/TLS data and login
#   connections. Corresponds to allow_anon_ssl in vsftpd.conf.
#
# @param anon_mkdir_write_enable
#   If true (and `write_enable` is also true), anonymous users are
#   permitted to create new directories. Corresponds to
#   anon_mkdir_write_enable in vsftpd.conf.
#
# @param anon_other_write_enable
#   If true (and `write_enable` is also true), anonymous users are
#   permitted to perform write operations other than upload and mkdir
#   (e.g. delete, rename). Corresponds to anon_other_write_enable in
#   vsftpd.conf.
#
# @param anon_upload_enable
#   If true (and `write_enable` is also true), anonymous users are
#   permitted to upload files. Corresponds to anon_upload_enable in
#   vsftpd.conf.
#
# @param anon_world_readable_only
#   If true, anonymous users may only download files which are
#   world-readable. Corresponds to anon_world_readable_only in
#   vsftpd.conf.
#
# @param anonymous_enable
#   If true, anonymous login is permitted. Corresponds to
#   anonymous_enable in vsftpd.conf.
#
# @param ascii_download_enable
#   If true, ASCII mangling is performed on file downloads (when
#   requested by the client). Corresponds to ascii_download_enable in
#   vsftpd.conf.
#
# @param ascii_upload_enable
#   If true, ASCII mangling is performed on file uploads (when requested
#   by the client). Corresponds to ascii_upload_enable in vsftpd.conf.
#
# @param async_abor_enable
#   If true, support for the non-standard "async ABOR" interrupt
#   mechanism is enabled. Corresponds to async_abor_enable in
#   vsftpd.conf.
#
# @param background
#   If true, vsftpd forks and backgrounds itself at startup, rather than
#   `run_as_launching_user`ing in the foreground. Corresponds to
#   background in vsftpd.conf.
#
# @param check_shell
#   If false, vsftpd does not check that local users' shells, as listed
#   in /etc/passwd, are listed in /etc/shells. Corresponds to
#   check_shell in vsftpd.conf.
#
# @param chmod_enable
#   If true, the FTP SITE CHMOD command is supported for local users.
#   Corresponds to chmod_enable in vsftpd.conf.
#
# @param chown_uploads
#   If true, files uploaded by anonymous users are owned by the
#   username given in `chown_username`. Corresponds to chown_uploads in
#   vsftpd.conf.
#
# @param chroot_list_enable
#   If true, the list of local users in the file specified by
#   `chroot_list_file` is used, in conjunction with
#   `chroot_local_user`, to control which users are chrooted into
#   their home directory. Corresponds to chroot_list_enable in
#   vsftpd.conf.
#
# @param chroot_local_user
#   If true, local users are placed in a chroot jail in their home
#   directory after login. Corresponds to chroot_local_user in
#   vsftpd.conf.
#
# @param connect_from_port_20
#   If true, PORT (active mode) data connections are sourced from port
#   20 (ftp-data) on the server. Corresponds to connect_from_port_20 in
#   vsftpd.conf.
#
# @param deny_email_enable
#   If true, anonymous logins using a password listed in the file
#   specified by `banned_email_file` are denied. Corresponds to
#   deny_email_enable in vsftpd.conf.
#
# @param dirlist_enable
#   If false, all directory listing is disabled, for both anonymous and
#   local users alike. Corresponds to dirlist_enable in vsftpd.conf.
#
# @param userlist_file
#   The path to the file to which vsftpd::user_list is rendered, and
#   which vsftpd consults per `userlist_enable`/`userlist_deny`.
#   Corresponds to userlist_file in vsftpd.conf.
#
# @param dirmessage_enable
#   If true, vsftpd displays the content of a per-directory message file
#   (given by `message_file`) when a directory is first entered.
#   Corresponds to dirmessage_enable in vsftpd.conf.
#
# @param download_enable
#   If false, all download requests are denied, for both anonymous and
#   local users alike. Corresponds to download_enable in vsftpd.conf.
#
# @param dual_log_enable
#   If true (and `xferlog_enable` is also true), vsftpd logs to both the
#   vsftpd-format log file (`vsftpd_log_file`) and the wu-ftpd-format
#   log file (`xferlog_file`). Corresponds to dual_log_enable in
#   vsftpd.conf.
#
# @param force_dot_files
#   If true, vsftpd will list files starting with a leading dot, other
#   than the traditional "." and "..". Corresponds to force_dot_files
#   in vsftpd.conf.
#
# @param force_anon_data_ssl
#   If true, anonymous users must use a secure SSL/TLS connection for
#   data transfer. Corresponds to force_anon_data_ssl in vsftpd.conf.
#
# @param force_anon_logins_ssl
#   If true, anonymous users must use a secure SSL/TLS connection to
#   send the password. Corresponds to force_anon_logins_ssl in
#   vsftpd.conf.
#
# @param force_local_data_ssl
#   If true, local (non-anonymous) users must use a secure SSL/TLS
#   connection for data transfer. Corresponds to force_local_data_ssl
#   in vsftpd.conf.
#
# @param force_local_logins_ssl
#   If true, local (non-anonymous) users must use a secure SSL/TLS
#   connection to send the password. Corresponds to
#   force_local_logins_ssl in vsftpd.conf.
#
# @param guest_enable
#   If true, local users other than the anonymous user are treated as
#   "guest" logins and mapped to the user specified by `nopriv_user` (or
#   `guest_username`). Corresponds to guest_enable in vsftpd.conf.
#
# @param hide_ids
#   If true, all user and group information in directory listings is
#   displayed as "ftp". Corresponds to hide_ids in vsftpd.conf.
#
# @param listen_ipv6
#   If true, put the server into standalone mode listening on an IPv6
#   socket, when IPv6 is supported by the underlying facts. Corresponds
#   to listen_ipv6 in vsftpd.conf.
#
# @param lock_upload_files
#   If true, vsftpd uses advisory file locking on uploaded files during
#   any period of the upload. Corresponds to lock_upload_files in
#   vsftpd.conf.
#
# @param log_ftp_protocol
#   If true (and `xferlog_std_format` is false), vsftpd will log all FTP
#   requests and responses, in addition to transfers. Corresponds to
#   log_ftp_protocol in vsftpd.conf.
#
# @param ls_recurse_enable
#   If true, support for the "ls -R" recursive listing option is
#   enabled. Corresponds to ls_recurse_enable in vsftpd.conf.
#
# @param mdtm_write
#   If true, support for the non-standard "site utime" command is
#   enabled, needed for the MDTM FTP command to be used for changing
#   file modification times. Corresponds to mdtm_write in vsftpd.conf.
#
# @param no_anon_password
#   If true, the anonymous user is not asked for a password when
#   logging in. Corresponds to no_anon_password in vsftpd.conf.
#
# @param no_log_lock
#   If true, vsftpd does not lock the log file that is used for the
#   standard vsftpd log format (`vsftpd_log_file`). Corresponds to
#   no_log_lock in vsftpd.conf.
#
# @param one_process_model
#   If true (and Linux only), vsftpd uses a security model which uses
#   one process per connection with no inter-process communication,
#   instead of the default two-process model. Corresponds to
#   one_process_model in vsftpd.conf.
#
# @param passwd_chroot_enable
#   If true (and `chroot_local_user` is also true), vsftpd will look for
#   the user's chroot root directory in /etc/passwd, using
#   `user_sub_token` substitution. Corresponds to passwd_chroot_enable
#   in vsftpd.conf.
#
# @param pasv_addr_resolve
#   If true, `pasv_address` is resolved as a DNS name rather than an IP
#   address. Corresponds to pasv_addr_resolve in vsftpd.conf.
#
# @param pasv_promiscuous
#   If true, vsftpd does not check that the IP address of the data
#   connection matches the IP address of the control connection in PASV
#   mode. Corresponds to pasv_promiscuous in vsftpd.conf.
#
# @param port_enable
#   If true, PORT (active mode) style data connections are supported.
#   Corresponds to port_enable in vsftpd.conf.
#
# @param port_promiscuous
#   If true, vsftpd does not check that the IP address of the data
#   connection matches the IP address of the control connection in PORT
#   mode. Corresponds to port_promiscuous in vsftpd.conf.
#
# @param reverse_lookup_enable
#   If true, vsftpd will attempt to perform reverse DNS lookups on
#   client IP addresses for logging and libwrap/tcpwrappers access
#   control purposes. Corresponds to reverse_lookup_enable in
#   vsftpd.conf.
#
# @param run_as_launching_user
#   If true, vsftpd drops the concept of a distinct vsftpd internal
#   (typically 'ftp') user, and instead impersonates the user that
#   launches vsftpd for all vsftpd activity. Corresponds to
#   run_as_launching_user in vsftpd.conf.
#
# @param secure_email_list_enable
#   If true (and `deny_email_enable` is also true), anonymous logins
#   using a password listed in `banned_email_file` are treated as an
#   invalid login, rather than merely a denied one. Corresponds to
#   secure_email_list_enable in vsftpd.conf.
#
# @param session_support
#   If true, vsftpd attempts to maintain and update utmp/wtmp log
#   entries for FTP sessions. Corresponds to session_support in
#   vsftpd.conf.
#
# @param setproctitle_enable
#   If true, vsftpd will report each session's status via the process
#   title (as shown by tools such as `ps`), e.g. showing the client IP
#   and current activity. Corresponds to setproctitle_enable in
#   vsftpd.conf.
#
# @param ssl_sslv2
#   If true, permit SSL v2 protocol connections. Corresponds to
#   ssl_sslv2 in vsftpd.conf.
#
# @param ssl_sslv3
#   If true, permit SSL v3 protocol connections. Corresponds to
#   ssl_sslv3 in vsftpd.conf.
#
# @param ssl_tlsv1
#   If true, permit TLS v1.0 protocol connections. Corresponds to
#   ssl_tlsv1 in vsftpd.conf.
#
# @param ssl_tlsv1_1
#   If true, permit TLS v1.1 protocol connections. Corresponds to
#   ssl_tlsv1_1 in vsftpd.conf.
#
# @param ssl_tlsv1_2
#   If true, permit TLS v1.2 protocol connections. Corresponds to
#   ssl_tlsv1_2 in vsftpd.conf.
#
# @param syslog_enable
#   If true (and `xferlog_enable` is also true), vsftpd will log to
#   syslog rather than to the file specified by `vsftpd_log_file`.
#   Corresponds to syslog_enable in vsftpd.conf.
#
# @param text_userdb_names
#   If true, textual usernames and group names are used in the output
#   of directory listings, rather than numeric IDs, even when a
#   NIS/remote user/group database is in use. Corresponds to
#   text_userdb_names in vsftpd.conf.
#
# @param tilde_user_enable
#   If true, vsftpd supports "~<user>" syntax for indicating the home
#   directory of a user, wherever the client specifies a file path.
#   Corresponds to tilde_user_enable in vsftpd.conf.
#
# @param use_localtime
#   If true, vsftpd will display directory listing times, and use for
#   the purposes of MDTM, in your machine's local time zone, rather
#   than GMT. Corresponds to use_localtime in vsftpd.conf.
#
# @param use_sendfile
#   If false, vsftpd will not use the sendfile() system call to
#   transmit files to clients. Corresponds to use_sendfile in
#   vsftpd.conf.
#
# @param userlist_log
#   If true, vsftpd will log denied login attempts (per userlist_deny)
#   from users named in the `vsftpd::user_list`. Corresponds to
#   userlist_log in vsftpd.conf.
#
# @param virtual_use_local_privs
#   If true, virtual users use the same privileges as local users,
#   rather than the (more restricted) privileges of anonymous users.
#   Corresponds to virtual_use_local_privs in vsftpd.conf.
#
# @param write_enable
#   If true, FTP commands which change the filesystem are permitted,
#   e.g. STOR, DELE, RNFR, RNTO, MKD, RMD, APPE, and SITE. Corresponds
#   to write_enable in vsftpd.conf.
#
# @param xferlog_enable
#   If true, vsftpd will log details of uploads/downloads to the log
#   file specified by `vsftpd_log_file` or `xferlog_file`. Corresponds
#   to xferlog_enable in vsftpd.conf.
#
# @param xferlog_std_format
#   If true, vsftpd will log transfers in the standard wu-ftpd-style
#   xferlog format, rather than vsftpd's own log format. Corresponds to
#   xferlog_std_format in vsftpd.conf.
#
# @param accept_timeout
#   The maximum time, in seconds, that a remote client is allowed to
#   spend negotiating a PASV style data connection. Corresponds to
#   accept_timeout in vsftpd.conf.
#
# @param anon_max_rate
#   The maximum data transfer rate permitted, in bytes per second, for
#   anonymous users. Corresponds to anon_max_rate in vsftpd.conf.
#
# @param anon_umask
#   The umask used for file creation by anonymous users. Corresponds to
#   anon_umask in vsftpd.conf.
#
# @param connect_timeout
#   The maximum time, in seconds, that a remote client is allowed to
#   spend negotiating a PORT style data connection. Corresponds to
#   connect_timeout in vsftpd.conf.
#
# @param data_connection_timeout
#   The maximum time, in seconds, that a data connection may stall for,
#   with no data transfer, before vsftpd will terminate the connection.
#   Corresponds to data_connection_timeout in vsftpd.conf.
#
# @param delay_failed_login
#   The delay, in seconds, before responding to a failed login attempt.
#   Corresponds to delay_failed_login in vsftpd.conf.
#
# @param delay_successful_login
#   The delay, in seconds, before responding to a successful login
#   attempt. Corresponds to delay_successful_login in vsftpd.conf.
#
# @param file_open_mode
#   The permissions with which any uploaded files are created (subject
#   to the umask setting). Corresponds to file_open_mode in
#   vsftpd.conf.
#
# @param idle_session_timeout
#   The maximum time, in seconds, that a remote client may spend
#   between FTP commands, before the session is closed. Corresponds to
#   idle_session_timeout in vsftpd.conf.
#
# @param local_max_rate
#   The maximum data transfer rate permitted, in bytes per second, for
#   local (authenticated) users. Corresponds to local_max_rate in
#   vsftpd.conf.
#
# @param local_umask
#   The umask used for file creation by local (authenticated) users.
#   Corresponds to local_umask in vsftpd.conf.
#
# @param max_clients
#   The maximum number of simultaneous clients permitted, beyond which
#   connections are refused. Corresponds to max_clients in vsftpd.conf.
#
# @param max_login_fails
#   The maximum number of failed logins permitted before the client is
#   disconnected. Corresponds to max_login_fails in vsftpd.conf.
#
# @param max_per_ip
#   The maximum number of simultaneous clients permitted from the same
#   source IP address. Corresponds to max_per_ip in vsftpd.conf.
#
# @param trans_chunk_size
#   The size, in bytes, of the chunks used by the underlying
#   sendfile/write system calls used to transmit a file. Corresponds to
#   trans_chunk_size in vsftpd.conf.
#
# @param anon_root
#   The directory that vsftpd will try to change to after an anonymous
#   login. Corresponds to anon_root in vsftpd.conf.
#
# @param banned_email_file
#   The path to the file which contains a list of anonymous email
#   passwords which are denied access, when `deny_email_enable` is set.
#   Corresponds to banned_email_file in vsftpd.conf.
#
# @param banner_file
#   The path to a file whose contents are displayed to the connecting
#   client before the login prompt. Corresponds to banner_file in
#   vsftpd.conf.
#
# @param chown_username
#   The username to which uploaded anonymous files are attributed, when
#   `chown_uploads` is set. Corresponds to chown_username in
#   vsftpd.conf.
#
# @param chroot_list_file
#   The path to the file containing the list of local users evaluated
#   by `chroot_list_enable`. Corresponds to chroot_list_file in
#   vsftpd.conf.
#
# @param cmds_allowed
#   Array of explicitly permitted FTP commands. If set, any FTP command
#   not in this list is rejected. Corresponds to cmds_allowed in
#   vsftpd.conf.
#
# @param deny_file
#   A regular expression (or glob) applied against filenames; matching
#   filenames are hidden from directory listings and access is denied.
#   Corresponds to deny_file in vsftpd.conf.
#
# @param dsa_cert_file
#   Path and name of the DSA certificate file to use for SSL
#   connections. Corresponds to dsa_cert_file in vsftpd.conf.
#
# @param dsa_private_key_file
#   Path and name of the DSA private key file to use for SSL
#   connections. Corresponds to dsa_private_key_file in vsftpd.conf.
#
# @param email_password_file
#   The path to the file containing a list of anonymous email passwords
#   which are permitted access, used in conjunction with
#   `secure_email_list_enable`. Corresponds to email_password_file in
#   vsftpd.conf.
#
# @param hide_file
#   A regular expression (or glob) applied against filenames; matching
#   filenames are hidden from directory listings, but access is still
#   permitted if the exact name is known. Corresponds to hide_file in
#   vsftpd.conf.
#
# @param listen_address6
#   The IPv6 address on which to listen for connections, if the
#   standalone vsftpd is handling both IPv4 and IPv6. Corresponds to
#   listen_address6 in vsftpd.conf.
#
# @param local_root
#   The directory that vsftpd will try to change to after a local
#   (authenticated) login. Corresponds to local_root in vsftpd.conf.
#
# @param message_file
#   The filename which, if it exists in a newly entered directory, is
#   displayed to the remote user when `dirmessage_enable` is set.
#   Corresponds to message_file in vsftpd.conf.
#
# @param nopriv_user
#   The unprivileged system user that vsftpd uses when it needs to
#   change to an unprivileged user, e.g. for the anonymous or guest FTP
#   account. Corresponds to nopriv_user in vsftpd.conf.
#
# @param pasv_address
#   The IP address (or resolvable name, with `pasv_addr_resolve`) to
#   report to clients as the address to connect to for PASV style data
#   connections. Corresponds to pasv_address in vsftpd.conf.
#
# @param validate_cert
#   If true, validate the client SSL certificate. Defaults to the value
#   of the `vsftpd::validate_cert` parameter. Corresponds to
#   validate_cert in vsftpd.conf.
#
# @param secure_chroot_dir
#   The path to an empty directory, not writable by the ftp user, used
#   by vsftpd as a secure chroot jail for various operations which do
#   not require access to the filesystem. Corresponds to
#   secure_chroot_dir in vsftpd.conf.
#
# @param user_config_dir
#   The path to a directory containing per-user configuration override
#   files, named after the local username. Corresponds to
#   user_config_dir in vsftpd.conf.
#
# @param user_sub_token
#   The string which, when found in various path options (such as
#   `local_root`), is substituted with the local username. Corresponds
#   to user_sub_token in vsftpd.conf.
#
# @param vsftpd_log_file
#   The path to the file to which vsftpd will write its standard-format
#   log, when `xferlog_std_format` is false. Corresponds to
#   vsftpd_log_file in vsftpd.conf.
#
# @param xferlog_file
#   The path to the file to which vsftpd will write its wu-ftpd-style
#   xferlog, when `xferlog_std_format` is true. Corresponds to
#   xferlog_file in vsftpd.conf.
#
# @param min_uid
#   The minimum UID used to populate /etc/ftpusers (via the ftpusers
#   define) with system accounts that should be denied FTP access. If
#   empty, /etc/ftpusers is not managed.
#
# * The rest of the parameters can be found on the vsftpd.conf man page *
#
# @author https://github.com/simp/pupmod-simp-vsftpd/graphs/contributors
#
class vsftpd::config (
  Optional[Boolean]              $allow_anon_ssl           = undef,
  Optional[Boolean]              $anon_mkdir_write_enable  = undef,
  Optional[Boolean]              $anon_other_write_enable  = undef,
  Boolean                        $anon_upload_enable       = true,
  Optional[Boolean]              $anon_world_readable_only = undef,
  Boolean                        $anonymous_enable         = true,
  Optional[Boolean]              $ascii_download_enable    = undef,
  Optional[Boolean]              $ascii_upload_enable      = undef,
  Optional[Boolean]              $async_abor_enable        = undef,
  Optional[Boolean]              $background               = undef,
  Optional[Boolean]              $check_shell              = undef,
  Optional[Boolean]              $chmod_enable             = undef,
  Optional[Boolean]              $chown_uploads            = undef,
  Optional[Boolean]              $chroot_list_enable       = undef,
  Optional[Boolean]              $chroot_local_user        = undef,
  Boolean                        $connect_from_port_20     = true,
  Optional[Boolean]              $deny_email_enable        = undef,
  Optional[Boolean]              $dirlist_enable           = undef,
  Boolean                        $dirmessage_enable        = true,
  Optional[Boolean]              $download_enable          = undef,
  Optional[Boolean]              $dual_log_enable          = undef,
  Optional[Boolean]              $force_dot_files          = undef,
  Optional[Boolean]              $force_anon_data_ssl      = undef,
  Optional[Boolean]              $force_anon_logins_ssl    = undef,
  Boolean                        $force_local_data_ssl     = true,
  Boolean                        $force_local_logins_ssl   = true,
  Optional[Boolean]              $guest_enable             = undef,
  Optional[Boolean]              $hide_ids                 = undef,
  Optional[Boolean]              $listen_ipv6              = undef,
  Optional[Boolean]              $lock_upload_files        = undef,
  Optional[Boolean]              $log_ftp_protocol         = undef,
  Optional[Boolean]              $ls_recurse_enable        = undef,
  Optional[Boolean]              $mdtm_write               = undef,
  Optional[Boolean]              $no_anon_password         = undef,
  Optional[Boolean]              $no_log_lock              = undef,
  Optional[Boolean]              $one_process_model        = undef,
  Optional[Boolean]              $passwd_chroot_enable     = undef,
  Optional[Boolean]              $pasv_addr_resolve        = undef,
  Optional[Boolean]              $pasv_promiscuous         = undef,
  Optional[Boolean]              $port_enable              = undef,
  Optional[Boolean]              $port_promiscuous         = undef,
  Optional[Boolean]              $reverse_lookup_enable    = undef,
  Optional[Boolean]              $run_as_launching_user    = undef,
  Optional[Boolean]              $secure_email_list_enable = undef,
  Optional[Boolean]              $session_support          = undef,
  Optional[Boolean]              $setproctitle_enable      = undef,
  Boolean                        $ssl_sslv2                = false,
  Boolean                        $ssl_sslv3                = false,
  Boolean                        $ssl_tlsv1                = false,
  Boolean                        $ssl_tlsv1_1              = false,
  Boolean                        $ssl_tlsv1_2              = true,
  Boolean                        $syslog_enable            = true,
  Optional[Boolean]              $text_userdb_names        = undef,
  Optional[Boolean]              $tilde_user_enable        = undef,
  Optional[Boolean]              $use_localtime            = undef,
  Optional[Boolean]              $use_sendfile             = undef,
  Stdlib::Absolutepath           $userlist_file            = '/etc/vsftpd/user_list',
  Boolean                        $userlist_log             = true,
  Optional[Boolean]              $virtual_use_local_privs  = undef,
  Boolean                        $write_enable             = true,
  Boolean                        $xferlog_enable           = true,
  Boolean                        $xferlog_std_format       = true,
  Optional[Integer]              $accept_timeout           = undef,
  Optional[Integer]              $anon_max_rate            = undef,
  Optional[Simplib::Umask]       $anon_umask               = undef,
  Optional[Integer]              $connect_timeout          = undef,
  Optional[Integer]              $data_connection_timeout  = undef,
  Optional[Integer]              $delay_failed_login       = undef,
  Optional[Integer]              $delay_successful_login   = undef,
  Optional[Simplib::Umask]       $file_open_mode           = undef,
  Optional[Integer]              $idle_session_timeout     = undef,
  Optional[Integer]              $local_max_rate           = undef,
  Simplib::Umask                 $local_umask              = '022',
  Optional[Integer]              $max_clients              = undef,
  Optional[Integer]              $max_login_fails          = undef,
  Optional[Integer]              $max_per_ip               = undef,
  Optional[Integer]              $trans_chunk_size         = undef,
  Optional[String]               $anon_root                = undef,
  Optional[Stdlib::Absolutepath] $banned_email_file        = undef,
  Stdlib::Absolutepath           $banner_file              = '/etc/issue.net',
  Optional[String]               $chown_username           = undef,
  Optional[Stdlib::Absolutepath] $chroot_list_file         = undef,
  Optional[Array[String]]        $cmds_allowed             = undef,
  Optional[String]               $deny_file                = undef, # can contain regex
  Optional[Stdlib::Absolutepath] $dsa_cert_file            = undef,
  Optional[Stdlib::Absolutepath] $dsa_private_key_file     = undef,
  Optional[Stdlib::Absolutepath] $email_password_file      = undef,
  Optional[String]               $hide_file                = undef, # can contain regex
  Optional[Simplib::IP::V6]      $listen_address6          = undef,
  Optional[Stdlib::Absolutepath] $local_root               = undef,
  Optional[Stdlib::Absolutepath] $message_file             = undef,
  Optional[String]               $nopriv_user              = undef,
  Optional[Simplib::Host]        $pasv_address             = undef,
  String                         $app_pki_external_source  = simplib::lookup('simp_options::pki::source', { 'default_value' => '/etc/pki/simp/x509' }),
  Stdlib::Absolutepath           $app_pki_dir              = '/etc/pki/simp_apps/vsftpd/x509',
  Stdlib::Absolutepath           $app_pki_cert             = "${app_pki_dir}/public/${facts['networking']['fqdn']}.pub",
  Stdlib::Absolutepath           $app_pki_key              = "${app_pki_dir}/private/${facts['networking']['fqdn']}.pem",
  Stdlib::Absolutepath           $app_pki_ca               = "${app_pki_dir}/cacerts/cacerts.pem",
  Boolean                        $validate_cert            = $vsftpd::validate_cert,
  Optional[Stdlib::Absolutepath] $secure_chroot_dir        = undef,
  Optional[Stdlib::Absolutepath] $user_config_dir          = undef,
  Optional[String]               $user_sub_token           = undef,
  Optional[Stdlib::Absolutepath] $vsftpd_log_file          = undef,
  Optional[Stdlib::Absolutepath] $xferlog_file             = undef,
  String                         $min_uid                  = '500'
) {
  assert_private()

  if ($vsftpd::listen_ipv4 and $listen_ipv6) {
    fail('$::vsftpd::listen_ipv4 and $::vsftpd::config::listen_ipv6 are mutually exculsive')
  }

  $_tcp_wrappers       = $vsftpd::tcpwrappers
  $_listen_port        = $vsftpd::listen_port
  $_listen_address     = $vsftpd::listen_address
  $_ftp_data_port      = $vsftpd::ftp_data_port
  $_pasv_enable        = $vsftpd::pasv_enable
  $_listen_ipv4        = $vsftpd::listen_ipv4
  $_ipv6_enabled       = $facts['ipv6_enabled']
  $_vsftpd_group       = $vsftpd::vsftpd_group
  $_ftp_username       = $vsftpd::vsftpd_user
  $_user_list          = $vsftpd::user_list
  $_guest_username     = $vsftpd::vsftpd_user
  $_userlist_deny      = $vsftpd::userlist_deny
  $_userlist_enable    = $vsftpd::userlist_enable
  $_pasv_max_port      = $vsftpd::pasv_max_port
  $_pasv_min_port      = $vsftpd::pasv_min_port
  $_local_enable       = $vsftpd::local_enable
  $_pam_service_name   = $vsftpd::pam_service_name
  $_ssl_enable         = $vsftpd::ssl_enable
  $_require_ssl_reuse  = $vsftpd::require_ssl_reuse
  $_ssl_ciphers        = $vsftpd::cipher_suite

  if $vsftpd::pki {
    simplib::assert_optional_dependency($module_name, 'simp/pki')

    pki::copy { 'vsftpd':
      source => $app_pki_external_source,
      pki    => $vsftpd::pki,
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
