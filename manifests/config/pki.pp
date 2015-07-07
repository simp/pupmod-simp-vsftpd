#
# == Class vsftpd::pki
#
#  Manages certs in /etc/vsftpd.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd::config::pki {
  include '::vsftpd'

  pki::copy { '/etc/vsftpd':
    group  => $::vsftpd::vsftpd_group,
    notify => Service['vsftpd']
  }

}
