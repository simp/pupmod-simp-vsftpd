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
class vsftpd::config::tcpwrappers (
  $allowed_nets = $vsftpd::params::allowed_nets,
  $tcp_wrappers = $vsftpd::params::tcp_wrappers
) inherits vsftpd::params {
  include '::vsftpd'

  validate_net_list($allowed_nets)
  validate_bool($tcp_wrappers)

  if $tcp_wrappers {
    include 'tcpwrappers'

    tcpwrappers::allow { 'vsftpd':
      pattern => $allowed_nets
    }
  }
  else {
    notify { 'allow_vsftpd':
      message => "TCPWrappers not detected, not setting tcpwrappers for $name"
    }
  }

}
