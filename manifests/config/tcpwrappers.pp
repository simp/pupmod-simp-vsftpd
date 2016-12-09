#
# == Class vsftpd::config::tcpwrappers
#
# Sets up tcpwrappers for vsfptd.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd::config::tcpwrappers {
  assert_private()

  include '::tcpwrappers'

  tcpwrappers::allow { 'vsftpd':
    pattern => $::vsftpd::trusted_nets
  }
}
