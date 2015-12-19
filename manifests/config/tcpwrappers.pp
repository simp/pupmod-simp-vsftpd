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

  if $::vsftpd::tcp_wrappers {
    include 'tcpwrappers'

    tcpwrappers::allow { 'vsftpd':
      pattern => $::vsftpd::client_nets
    }
  }
  else {
    notify { 'allow_vsftpd':
      message => "TCPWrappers not detected, not setting tcpwrappers for ${name}"
    }
  }

}
