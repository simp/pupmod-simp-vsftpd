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
# [*manage_firewall*]
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
    # Conf Options #
    $user_list       = ['root','bin','daemon','adm','lp','sync','shutdown','halt','mail','news','uucp',	'operator','games','nobody']
  }
  else {
    fail("Unsupported Operating System ${::operatingsystem}")
  }
}
