# This class sets up the appropriate IPtables rules based on the value of
# $fw_rules.
#
# By default, it will allow access only to localhost, you will need to
# define an array at fw_rules to add additional hosts.
#
# Localhost is always listed as a host that is allowed to access the system.
#
# @author https://github.com/simp/pupmod-simp-vsftpd/graphs/contributors
#
class vsftpd::config::firewall {
  assert_private()

  # TODO support ipv6
  if $vsftpd::listen_ipv4 {
    simplib::assert_optional_dependency($module_name, 'simp/iptables')

    include 'iptables'

    iptables::listen::tcp_stateful { 'allow_vsftpd_data_port':
      trusted_nets => $vsftpd::trusted_nets,
      dports       => $vsftpd::ftp_data_port
    }

    iptables::listen::tcp_stateful { 'allow_vsftpd_listen_port':
      trusted_nets => $vsftpd::trusted_nets,
      dports       => $vsftpd::listen_port
    }

    if $vsftpd::pasv_enable {
      if $vsftpd::pasv_min_port and $vsftpd::pasv_max_port {
        iptables::listen::tcp_stateful { 'allow_vsftpd_pasv_ports':
          trusted_nets => $vsftpd::trusted_nets,
          dports       => "${vsftpd::pasv_min_port}:${vsftpd::pasv_max_port}",
        }
      }
      elsif $vsftpd::pasv_min_port or $vsftpd::pasv_max_port {
        fail("\$vsftpd::pasv_min_port ('${vsftpd::pasv_min_port}') and \$vsftpd::pasv_max_port ('${vsftpd::pasv_max_port}') must both be defined (or not defined)")
      }

      sysctl { 'net.netfilter.nf_conntrack_helper':
        value  => '1',
        silent => true
      }

      if defined(Class['firewalld::reload']) {
        Class['firewalld::reload'] -> Sysctl['net.netfilter.nf_conntrack_helper']
      }

      if defined(Class['iptables::service']) {
        Class['iptables::service'] -> Sysctl['net.netfilter.nf_conntrack_helper']
      }
    }
  }
}
