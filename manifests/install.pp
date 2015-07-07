#
# == Class vsftpd::install
#
# Installs vsftpd and optionally manages the vsftpd group
# and user.
#
# == Parameters
#
# [*uid*]
#   Integer.  UID of the vsftpd user.
#   Defaults to 14.
#
# [*gid*]
#   Integer. GID of the vsftpd group.
#   Defaults to 50.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd::install (
  $uid = '14',
  $gid = '50',
){
  include '::vsftpd'

  validate_integer($uid)
  validate_integer($gid)

  if $::vsftpd::manage_group {
    group { $::vsftpd::vsftpd_group:
      ensure    => 'present',
      allowdupe => false,
      gid       => $gid
    }
  }

  if $::vsftpd::manage_user {
    user { $::vsftpd::vsftpd_user:
      ensure     => 'present',
      allowdupe  => false,
      gid        => $::vsftpd::vsftpd_group,
      home       => '/var/ftp',
      membership => 'inclusive',
      shell      => '/sbin/nologin',
      uid        => $uid,
      require    => Group[$::vsftpd::vsftpd_group],
      notify     => Service['vsftpd']
    }
  }

  if $::vsftpd::manage_group and $::vsftpd::manage_user {
    package { 'vsftpd':
      ensure  => 'latest',
      require => [Group[$::vsftpd::vsftpd_group],User[$::vsftpd::vsftpd_user]]
    }
  }
  else {
    package { 'vsftpd':
      ensure  => 'latest'
    }
  }
}
