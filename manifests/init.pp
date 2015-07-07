#
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
# [*enable_firewall*]
#   Type: Boolean
#   Default: +false+
#   If true, manage firewall rules to acommodate <%= metadata.name %>.
#
# [*enable_pki*]
#   Type: Boolean
#   Default: +false+
#   If true, manage PKI/PKE configuration for <%= metadata.name %>.
#
# [*enable_tcpwrappers*]
#   Type: Boolean
#   Default: +false+
#   If true, manage TCP wrappers configuration for <%= metadata.name %>.
# One thing to note is that local users are forced to SSL for security
# reasons.
#
# == Example
#
#  vsftpd { 'default':
#    allowed_nets => [ '10.0.0.0/8', '192.168.0.14' ]
#  }
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd (
  $vsftpd_user        = $::vsftpd::params::vsftpd_user,
  $vsftpd_group       = $::vsftpd::params::vsftpd_group,
  $manage_user        = $::vsftpd::params::manage_user,
  $manage_group       = $::vsftpd::params::manage_group,
  $manage_iptables    = $::vsftpd::params::manage_iptables,
  $allowed_nets       = $::vsftpd::params::allowed_nets,
  $ftp_data_port      = $::vsftpd::params::ftp_data_port,
  $listen_ipv4        = $::vsftpd::params::listen_ipv4,
  $listen_port        = $::vsftpd::params::listen_port,
  $pasv_enable        = $::vsftpd::params::pasv_enable,
  $tcp_wrappers       = $::vsftpd::params::tcp_wrappers,
  $client_nets        = defined('$::client_nets') ? { true => $::client_nets, default => hiera('client_nets', ['127.0.0.1/32']) },
  $enable_firewall    = defined('$::enable_firewall') ? { true => $::enable_firewall, default => hiera('enable_firewall',false) },
  $enable_pki         = defined('$::enable_pki') ? { true => $::enable_pki, default => hiera('enable_pki',false) },
  $enable_tcpwrappers = defined('$::enable_tcpwrappers') ? { true => $::enable_tcpwrappers, default => hiera('enable_tcpwrappers',false) }
) inherits ::vsftpd::params {

  validate_string($vsftpd_user)
  validate_string($vsftpd_group)
  validate_bool($manage_user)
  validate_bool($manage_group)
  validate_bool($manage_iptables)
  validate_net_list($allowed_nets)
  validate_integer($ftp_data_port)
  validate_bool($listen_ipv4)
  validate_integer($listen_port)
  validate_bool($pasv_enable)
  validate_bool($tcp_wrappers)
  validate_net_list($client_nets)
  validate_bool($enable_firewall)
  validate_bool($enable_pki)
  validate_bool($enable_tcpwrappers)

  include '::vsftpd::install'
  include '::vsftpd::config'
  include '::vsftpd::service'
  Class['::vsftpd::install'] ->
  Class['::vsftpd::config'] ~>
  Class['::vsftpd::service'] ->
  Class['::vsftpd']

  if $enable_firewall {
    include '::vsftpd::config::firewall'
    Class['::vsftpd::config::firewall'] ->
    Class['::vsftpd::service']
  }
  if $enable_pki {
    include '::vsftpd::config::pki'
    Class['::vsftpd::config::pki'] ->
    Class['::vsftpd::service']
  }
  if $enable_tcpwrappers {
    include '::vsftpd::config::tcpwrappers'
    Class['::vsftpd::config::tcpwrappers'] ->
    Class['::vsftpd::service']
  }
}
