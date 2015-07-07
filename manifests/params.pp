# == Class vsftpd::params
#
# == Parameters
#
# Conf optionts can be found on the vsftpd.conf man page
#
# [*vsfptd_user*]
#   Set the user for the vsftpd service.
#   Defaults to vsftpd in simp < 5.X, ftp otherwise.
#
# [*vsftpd_group*]
#   Set the group for the vsftpd service and files.
#   Defaults to vsftpd in simp < 5.X , ftp otherwise.
#
# [*manage_user*]
#   Manage vsftpd user.
#   Defaults to true.
#
# [*manage_group*]
#   Manage vsftpd group.
#   Defaults to true.
#
# [*manage_iptables*]
#   Manage iptables rules.
#   Defaults to true.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd::params {
  if $::operatingsystem in ['RedHat','CentOS'] {
    $vsftpd_user     = versioncmp(simp_version(),'5') ? { '-1' => 'vsftpd', default => 'ftp'}
    $vsftpd_group    = versioncmp('5.0.0','5') ? { '-1' => 'vsftpd', default => 'ftp'}
    $manage_user     = true
    $manage_group    = true
    $manage_iptables = true
    # Conf Options
    $allowed_nets    = ['127.0.0.1']
    $ftp_data_port   = '20'
    $listen_ipv4     = true
    $listen_port     = '21'
    $pasv_enable     = true
    $tcp_wrappers    = true
  }
}
