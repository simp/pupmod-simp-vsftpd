# Ensures the vsftpd service is running.
#
# @author https://github.com/simp/pupmod-simp-vsftpd/graphs/contributors
#
class vsftpd::service {
  assert_private()

  service { 'vsftpd':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

}
