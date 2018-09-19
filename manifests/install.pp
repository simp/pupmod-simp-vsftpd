# Installs vsftpd and optionally manages the vsftpd group
# and user.
#
# @author https://github.com/simp/pupmod-simp-vsftpd/graphs/contributors
#
class vsftpd::install {
  assert_private()

  package { 'vsftpd':
    ensure  => 'latest'
  }

}
