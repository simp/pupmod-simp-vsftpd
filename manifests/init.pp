#
# == Class: vsftpd
#
# This class configures a vsftpd server.  It ensures that the appropriate
# files are in the appropriate places and synchronizes the external
# materials.
#
# == Parameters
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
#
class vsftpd {

  if $::operatingsystem in ['RedHat','CentOS'] and $::operatingsystemmajrelease < '7' {
    $l_group = 'vsftpd'
  }
  else {
    $l_group = 'ftp'
  }

  file { '/etc/vsftpd':
    ensure   => 'directory',
    owner    => 'root',
    group    => $l_group,
    mode     => '0640',
    recurse  => true,
    checksum => undef,
    purge    => true,
    require  => Package['vsftpd']
  }

  file { '/etc/vsftpd/ftpusers':
    owner    => 'root',
    group    => $l_group,
    mode     => '0640',
    source   => 'puppet:///modules/vsftpd/ftpusers',
    notify   => Service['vsftpd'],
    require  => Package['vsftpd']
  }

  file { '/etc/vsftpd/user_list':
    owner    => 'root',
    group    => $l_group,
    mode     => '0640',
    source   => 'puppet:///modules/vsftpd/user_list',
    notify   => Service['vsftpd'],
    require  => Package['vsftpd']
  }

  file { '/etc/pam.d/vsftpd':
    owner    => 'root',
    group    => 'root',
    mode     => '0640',
    source   => 'puppet:///modules/vsftpd/vsftpd.pam',
    require  => Package['vsftpd']
  }

  group { $l_group:
    ensure    => 'present',
    allowdupe => false,
    gid       => '50'
  }

  # Make sure that the thing's the latest version before we try to do stuff.
  package { 'vsftpd': ensure => 'latest' }

  user { 'ftp':
    ensure     => 'present',
    allowdupe  => false,
    gid        => $l_group,
    home       => '/var/ftp',
    membership => 'inclusive',
    shell      => '/sbin/nologin',
    uid        => '14',
    require    => Group[$l_group],
    notify     => Service['vsftpd']
  }

  pki::copy { '/etc/vsftpd':
    group  => $l_group,
    notify => Service['vsftpd']
  }

  service { 'vsftpd':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
}
