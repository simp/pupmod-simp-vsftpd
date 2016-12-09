#
# == Class vsftpd::pki
#
#  Manages certs in $::vsftpd::app_pki_cert_source.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd::config::pki {
  assert_private()

  include '::pki'
  pki::copy { $::vsftpd::app_pki_cert_source:
    group  => $::vsftpd::vsftpd_group,
    notify => Service['vsftpd']
  }
}
