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
class vsftpd::install (
  $manage_group = $vsftpd::params::manage_group,
  $manage_user  = $vsftpd::params::manage_user,
  $vsftpd_group = $vsftpd::params::vsftpd_group,
  $vsftpd_user  = $vsftpd::params::vsftpd_user,
) inherits vsftpd::params {
  include '::vsftpd'

  if $manage_group {
    group { $vsftpd_group:
      ensure    => 'present',
      allowdupe => false,
      gid       => '50'
    }
  }

  if $manage_user {
    user { $vsftpd_user:
      ensure     => 'present',
      allowdupe  => false,
      gid        => $vsftpd_group,
      home       => '/var/ftp',
      membership => 'inclusive',
      shell      => '/sbin/nologin',
      uid        => '14',
      require    => Group[$vsftpd_group],
      notify     => Service['vsftpd']
    }
  }

  package { 'vsftpd':
    ensure  => 'latest',
    require => [Group[$vsftpd_group],User[$vsftpd_user]]
  }

  validate_bool($manage_group)
  validate_bool($manage_user)
  validate_string($vsftpd_user)
  validate_string($vsftpd_group)
}
