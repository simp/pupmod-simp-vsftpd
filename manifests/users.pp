# Manages the vsftpd group and user.
#
# @author https://github.com/simp/pupmod-simp-vsftpd/graphs/contributors
#
class vsftpd::users {
  assert_private()

  if $vsftpd::manage_group {
    group { $vsftpd::vsftpd_group:
      ensure    => 'present',
      allowdupe => false,
      gid       => $vsftpd::vsftpd_gid
    }
  }

  if $vsftpd::manage_user {
    user { $vsftpd::vsftpd_user:
      ensure     => 'present',
      allowdupe  => false,
      gid        => $vsftpd::vsftpd_group,
      home       => '/var/ftp',
      membership => 'inclusive',
      shell      => '/sbin/nologin',
      uid        => $vsftpd::vsftpd_uid,
    }
  }
}
