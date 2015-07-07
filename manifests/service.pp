# == Class vsftpd::service
#
# Ensures the vsftpd service is running.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd::service {

  service { 'vsftpd':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

}
