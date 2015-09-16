# == Class vsftpd::params
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
# [*vsftpd_uid*]
#   Integer.  UID of the vsftpd user.
#   Defaults to 14.
#
# [*vsftpd_gid*]
#   Integer. GID of the vsftpd group.
#   Defaults to 50.
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
    $vsftpd_user     = 'ftp'
    $vsftpd_group    = 'ftp'
    $vsftpd_uid      = '14'
    $vsftpd_gid      = '50'
    $manage_user     = true
    $manage_group    = true
    $manage_iptables = true
    # Conf Options #
    $allowed_nets    = defined('$::client_nets') ? { true => $::client_nets, default => hiera('client_nets', ['127.0.0.1/32']) }
    $ftp_data_port   = '20'
    $listen_ipv4     = true
    $listen_port     = '21'
    $pasv_enable     = true
    $tcp_wrappers    = true
    $user_list       = ['root','bin','daemon','adm','lp','sync','shutdown','halt','mail','news','uucp',	'operator','games','nobody']
    $userlist_enable = true
    $userlist_deny   = true
  }
  else {
    fail("Unsupported Operating System ${::operatingsystem}")
  }
}
