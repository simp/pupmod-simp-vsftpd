#
# == Class vsftpd::pki
#
#  Manages certs in $::vsftpd::app_pki_dir.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd::config::pki {
  assert_private()

  include '::pki'
  pki::copy { $::vsftpd::app_pki_dir:
    group  => $::vsftpd::vsftpd_group,
    notify => Service['vsftpd']
  }
}
