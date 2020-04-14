# Sets up tcpwrappers for vsfptd.
#
# @author https://github.com/simp/pupmod-simp-vsftpd/graphs/contributors
#
class vsftpd::config::tcpwrappers {
  assert_private()

  simplib::assert_optional_dependency($module_name, 'simp/tcpwrappers')

  include '::tcpwrappers'

  tcpwrappers::allow { 'vsftpd':
    pattern => $::vsftpd::trusted_nets
  }
}
