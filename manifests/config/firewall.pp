#
# == Class vsftpd::config::firewall
#
# This class sets up the appropriate IPtables rules based on the value of
# $fw_rules.
#
# By default, it will allow access only to localhost, you will need to
# define an array at fw_rules to add additional hosts.
#
# Localhost is always listed as a host that is allowed to access the system.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class vsftpd::config::firewall {
  include '::vsftpd'

  if $::vsftpd::manage_iptables {
    include 'iptables'

    # Only apply the IPTables rules if iptables is an included class.
    if $::vsftpd::listen_ipv4 {
      iptables::add_tcp_stateful_listen { 'allow_vsftpd_data_port':
        client_nets => $::vsftpd::allowed_nets,
        dports      => $::vsftpd::ftp_data_port
      }

      iptables::add_tcp_stateful_listen { 'allow_vsftpd_listen_port':
        client_nets => $::vsftpd::allowed_nets,
        dports      => $::vsftpd::listen_port
      }

      if $::vsftpd::pasv_enable {

        # This feels like a hack.
        exec { 'check_conntrack_ftp':
          command => '/bin/true',
          onlyif  => '/bin/grep -F "nf_conntrack_ftp" /proc/modules; test $? -ne 0',
          notify  => Service['iptables']
        }

        exec { 'nf_conntrack_ftp':
          command     => '/sbin/modprobe -q nf_conntrack_ftp',
          refreshonly => true,
          subscribe   => Service['iptables']
        }
      }
    }
  }

}
