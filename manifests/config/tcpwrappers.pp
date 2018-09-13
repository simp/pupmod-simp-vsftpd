# Sets up tcpwrappers for vsfptd.
#
# @author https://github.com/simp/pupmod-simp-vsftpd/graphs/contributors
#
class vsftpd::config::tcpwrappers {
  assert_private()

  include '::tcpwrappers'

  tcpwrappers::allow { 'vsftpd':
    pattern => $::vsftpd::trusted_nets
  }
}
