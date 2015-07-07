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
class vsftpd::config::pki (
  $vsftpd_group = $vsftpd::params::vsftpd_group
) inherits vsftpd::params {
  include '::vsftpd'

  pki::copy { '/etc/vsftpd':
    group  => $vsftpd_group,
    notify => Service['vsftpd']
  }

  validate_string($vsftpd_group)

}
