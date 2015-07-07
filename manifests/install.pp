#
# == Class vsftpd::install
#
# Installs vsftpd and optionally manages the vsftpd group
# and user.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd::install {
  include '::vsftpd'

  if $::vsftpd::manage_group {
    group { $::vsftpd::vsftpd_group:
      ensure    => 'present',
      allowdupe => false,
      gid       => $::vsftpd::vsftpd_gid
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
      uid        => $::vsftpd::vsftpd_uid,
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
