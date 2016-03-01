
# == Class: vsftpd
#
# This class configures a vsftpd server.  It ensures that the appropriate
# files are in the appropriate places and synchronizes the external
# materials.
#
# == Parameters
# [*client_nets*]
#   Type: Array of Strings
#   Default: +['127.0.0.1/32']+
#   A whitelist of subnets (in CIDR notation) permitted access.
#
# [*manage_firewall*]
#   Type: Boolean
#   Default: +false+
#   If true, manage firewall rules to acommodate <%= metadata.name %>.
#
# [*manage_pki*]
#   Type: Boolean
#   Default: +false+
#   If true, manage PKI/PKE configuration for <%= metadata.name %>.
#
# [*manage_tcpwrappers*]
#   Type: Boolean
#   Default: +false+
#   If true, use SIMP's TCP Wrapper management to configure TCP Wrappers to
#   acommodate <%= metadata.name %>.
#
# [*use_fips*]
#   Type: Boolean
#   Default: +false+, or the value of the +fips_enabled+ fact If true,
#   configure vsftpd to run in FIPS mode.  Note that even if this parameter is
#   false, vsftpd will be configured to be FIPS-compliant if the system is
#   running in FIPS mode.
#
# One thing to note is that local users are forced to SSL for security
# reasons.
#
# == Example
#
#  vsftpd { 'default':
#    client_nets => [ '10.0.0.0/8', '192.168.0.14' ]
#  }
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
# * Chris Tessmer <chris.tessmer@onyxpoint.com>
#
class vsftpd (
  # SIMP options
  $manage_firewall    = defined('$::manage_firewall') ? { true    => $::manage_firewall, default    => hiera('manage_firewall',false) },
  $manage_pki         = defined('$::manage_pki') ? { true         => $::manage_pki, default         => hiera('manage_pki',false) },
  $manage_tcpwrappers = defined('$::manage_tcpwrappers') ? { true => $::manage_tcpwrappers, default => hiera('manage_tcpwrappers',false) },
  $client_nets        = defined('$::client_nets') ? { true        => $::client_nets, default        => hiera('client_nets', ['127.0.0.1/32']) },
  $use_fips           =  $::vsftpd::params::use_fips,
  # certs
  $pki_certs_dir      = '/etc/vsftpd',

  # vsftpd.conf options
  $manage_user        = true,
  $manage_group       = true,
  $ftp_data_port      = '20',
  $listen_address     = undef,
  $listen_ipv4        = true,
  $listen_port        = '21',
  $local_enable       = true,
  $pasv_enable        = true,
  $pasv_max_port      = undef,
  $pasv_min_port      = undef,
  $ssl_enable         = true,
  $require_ssl_reuse  = true,
  $tcp_wrappers       = true,
  $userlist_deny      = true,
  $userlist_enable    = true,
  $user_list          = $::vsftpd::params::user_list,
  $pam_service_name   = $::vsftpd::params::pam_service_name,
  $validate_cert      = true,
  $vsftpd_gid         = '50',
  $vsftpd_group       = 'ftp',
  $vsftpd_uid         = '14',
  $vsftpd_user        = 'ftp',
) inherits ::vsftpd::params {

  validate_string($vsftpd_user)
  validate_string($vsftpd_group)
  validate_integer($vsftpd_uid)
  validate_integer($vsftpd_gid)
  validate_bool($manage_user)
  validate_bool($manage_group)
  validate_bool($manage_firewall)
  validate_net_list($client_nets)
  validate_integer($ftp_data_port)
  validate_bool($listen_ipv4)
  validate_integer($listen_port)
  validate_bool($pasv_enable)
  validate_bool($tcp_wrappers)
  validate_array($user_list)
  validate_bool($local_enable)
  validate_bool($userlist_enable)
  validate_bool($userlist_deny)
  validate_string($pam_service_name)
  validate_bool($manage_pki)
  validate_bool($require_ssl_reuse)
  validate_bool($manage_tcpwrappers)
  validate_string($pki_certs_dir)
  validate_bool($ssl_enable)
  validate_bool($use_fips)
  if $pasv_max_port { validate_integer($pasv_max_port) }
  if $pasv_min_port { validate_integer($pasv_min_port) }

  compliance_map()

  # regardless of the $vsftpd::use_fips parameter, configure vsftpd for FIPS if
  # the system is already running in FIPS mode.
  $_enable_fips = $use_fips or $vsftpd::params::use_fips

  include '::vsftpd::install'
  include '::vsftpd::config'
  include '::vsftpd::service'
  Class['::vsftpd::install'] ->
  Class['::vsftpd::config'] ~>
  Class['::vsftpd::service'] ->
  Class['::vsftpd']

  if $manage_firewall {
    include '::vsftpd::config::firewall'
    Class['::vsftpd::config::firewall'] ->
    Class['::vsftpd::service']
  }
  if $manage_pki {
    include '::vsftpd::config::pki'
    Class['::vsftpd::config::pki'] ->
    Class['::vsftpd::service']
  }
  if $manage_tcpwrappers {
    include '::vsftpd::config::tcpwrappers'
    Class['::vsftpd::config::tcpwrappers'] ->
    Class['::vsftpd::service']
  }
}
