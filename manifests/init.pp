#
# == Class: vsftpd
#
# This class configures a vsftpd server.  It ensures that the appropriate
# files are in the appropriate places and synchronizes the external
# materials.  
#
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
class vsftpd inherits vsftpd::params {

  include '::vsftpd::install'
  include '::vsftpd::config'
  include '::vsftpd::service'
  Class['vsftpd::install'] ~>
  Class['vsftpd::config'] ~>
  Class['vsftpd::service']

  if $::use_simp_firewall or hiera('use_simp_firewall',false) {
    include '::vsftpd::config::firewall'
    Class['vsftpd::config'] -> Class['vsftpd::config::firewall']
  }
  if $::use_simp_pki or hiera('use_simp_pki',false) {
    include '::vsftpd::config::pki'
    Class['vsftpd::config'] -> Class['vsftpd::config::pki']
  }
  if $::use_simp_tcpwrappers or hiera('use_simp_tcpwrappers',false) {
    include '::vsftpd::config::tcpwrappers'
    Class['vsftpd::config'] -> Class['vsftpd::config::tcpwrappers']
  }
}
