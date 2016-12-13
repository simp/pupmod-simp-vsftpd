# == Class vsftpd::params
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd::params {
  if $facts['operatingsystem'] in ['RedHat','CentOS'] {
    # Conf Options #
    $user_list = ['root','bin','daemon','adm','lp','sync','shutdown','halt','mail','news','uucp','operator','games','nobody']
    $pam_service_name = 'vsftpd'
  }
  else {
    fail("Unsupported Operating System ${::operatingsystem}")
  }
}
