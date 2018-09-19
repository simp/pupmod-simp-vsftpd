# This class configures a vsftpd server.  It ensures that the appropriate
# files are in the appropriate places and synchronizes the external
# materials.
#
# @param trusted_nets
#   A whitelist of subnets (in CIDR notation) permitted access.
#
# @param firewall
#   If true, use SIMP's ::iptables to manage firewall rules to accommodate <%= metadata.name %>.
#
# @param pki
#   * If 'simp', include SIMP's pki module and use pki::copy to manage
#     application certs in /etc/pki/simp_apps/vsftpd/x509
#   * If true, do *not* include SIMP's pki module, but still use pki::copy
#     to manage certs in /etc/pki/simp_apps/vsftpd/x509
#   * If false, do not include SIMP's pki module and do not use pki::copy
#     to manage certs.  You will need to appropriately assign a subset of:
#     * app_pki_dir
#     * app_pki_key
#     * app_pki_cert
#     * app_pki_ca
#     * app_pki_ca_dir
#
# @param tcpwrappers
#   If true, use SIMP's ::tcpwrappers to configure TCP Wrappers to
#   accommodate <%= metadata.name %> and set 'tcp_wrappers' value in
#   vsftpd.conf to true.
#
# @param haveged
#   If true, include ::haveged to assist with entropy generation.
#
# @param cipher_suite
#   OpenSSL cipher suite to use.
#   If you are not using this with ::simp_options and the server is in FIPS
#   mode, you need to set this to a FIPS-compliant cipher suite, (e.g.,
#   ['FIPS', '!LOW']).
#   Corresponds to ssl_ciphers in vsftpd.conf.
#
# @param vsfptd_user
#   Set the user for the vsftpd service.
#
# @param vsftpd_group
#   Set the group for the vsftpd service and files.
#
# @param manage_user
#   Manage vsftpd user.
#
# @param vsftpd_uid
#   Integer.  UID of the vsftpd user.
#
# @param vsftpd_gid
#   Integer. GID of the vsftpd group.
#
# @param manage_group
#   Manage vsftpd group.
#
#
# One thing to note is that local users are forced to SSL for security
# reasons.
#
# @author https://github.com/simp/pupmod-simp-vsftpd/graphs/contributors
#
class vsftpd (
  # SIMP options
  Boolean                            $firewall          = simplib::lookup('simp_options::firewall', { 'default_value' => false }),
  Variant[Enum['simp'],Boolean]      $pki               = simplib::lookup('simp_options::pki', { 'default_value' => false }),
  Boolean                            $tcpwrappers       = simplib::lookup('simp_options::tcpwrappers', { 'default_value' => false }),
  Simplib::Netlist                   $trusted_nets      = simplib::lookup('simp_options::trusted_nets', { 'default_value' => ['127.0.0.1','::1'] }),
  Boolean                            $haveged           = simplib::lookup('simp_options::haveged', { 'default_value' => false }),
  Array[String]                      $cipher_suite      = simplib::lookup('simp_options::openssl::cipher_suite', { 'default_value' => ['DEFAULT','!MEDIUM'] }),

  # vsftpd.conf options
  Boolean                            $manage_user       = true,
  Boolean                            $manage_group      = true,
  Simplib::Port                      $ftp_data_port     = 20,
  Optional[Simplib::IP::V4]          $listen_address    = undef,
  Boolean                            $listen_ipv4       = true, # listen config item in vsftpd.conf
  Simplib::Port                      $listen_port       = 21,
  Boolean                            $local_enable      = true,
  Boolean                            $pasv_enable       = true,
  Optional[Simplib::Port]            $pasv_max_port     = undef,
  Optional[Simplib::Port]            $pasv_min_port     = undef,
  Boolean                            $ssl_enable        = true,
  Boolean                            $require_ssl_reuse = true,
  Boolean                            $userlist_deny     = true,
  Boolean                            $userlist_enable   = true,
  Array[String]                      $user_list         = ['root','bin','daemon','adm','lp','sync','shutdown','halt','mail','news','uucp','operator','games','nobody'],
  String                             $pam_service_name  = 'vsftpd',
  Boolean                            $validate_cert     = true,
  Integer                            $vsftpd_gid        = 50,
  String                             $vsftpd_group      = 'ftp',
  Integer                            $vsftpd_uid        = 14,
  String                             $vsftpd_user       = 'ftp',
) {

  if $haveged and $ssl_enable {
    include 'haveged'
  }

  include 'vsftpd::users'
  include 'vsftpd::install'
  include 'vsftpd::config'
  include 'vsftpd::service'

  Class['vsftpd::users']
  -> Class['vsftpd::install']
  -> Class['vsftpd::config']
  ~> Class['vsftpd::service']
  -> Class['vsftpd']

  if $firewall {
    include 'vsftpd::config::firewall'
    Class['vsftpd::config::firewall'] -> Class['vsftpd::service']
  }
  if $tcpwrappers {
    include 'vsftpd::config::tcpwrappers'
    Class['vsftpd::config::tcpwrappers'] -> Class['vsftpd::service']
  }
}
