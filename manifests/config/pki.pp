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
  assert_private()

  pki::copy { $::vsftpd::pki_certs_dir:
    group  => $::vsftpd::vsftpd_group,
    notify => Service['vsftpd']
  }
}
