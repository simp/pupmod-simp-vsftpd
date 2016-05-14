Summary: vsftpd Puppet Module
Name: pupmod-vsftpd
Version: 5.0.1
Release: 0
License: Apache License, Version 2.0
Group: Applications/System
Source: %{name}-%{version}-%{release}.tar.gz
Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Requires: pupmod-common >= 4.2.0-0
Requires: pupmod-simplib >= 1.0.0-0
Requires: pupmod-iptables >= 4.1.0-3
Requires: pupmod-pki >= 4.1.0-0
Requires: pupmod-stunnel >= 4.2.0-0
Requires: pupmod-tcpwrappers >= 2.1.0-0
Requires: puppet >= 3.3.0
Requires: puppetlabs-stdlib >= 4.1.0-0
Buildarch: noarch
Requires: simp-bootstrap >= 4.2.0
Obsoletes: pupmod-vsftpd-test
Requires: pupmod-onyxpoint-compliance_markup

Prefix: /etc/puppet/environments/simp/modules

%description
This Puppet module provides the capability to configure vsftpd.

%prep
%setup -q

%build

%install
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/vsftpd

dirs='files lib manifests templates'
for dir in $dirs; do
  test -d $dir && cp -r $dir %{buildroot}/%{prefix}/vsftpd
done

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/vsftpd

%files
%defattr(0640,root,puppet,0750)
%{prefix}/vsftpd

%post
#!/bin/sh

if [ -d %{prefix}/vsftpd/plugins ]; then
  /bin/mv %{prefix}/vsftpd/plugins %{prefix}/vsftpd/plugins.bak
fi

%postun
# Post uninstall stuff

%changelog
* Wed May 18 2016 Chris Tessmer <chris.tessmer@onypoint.com> - 5.0.1-0
- Sanitize code for `STRICT_VARIABLES=yes`

* Tue Mar 01 2016 Ralph Wright <ralph.wright@onyxpoint.com> - 5.0.0-2
- Added compliance function support

* Mon Nov 09 2015 Chris Tessmer <chris.tessmer@onypoint.com> - 5.0.0-1
- migration to simplib and simpcat (lib/ only)

* Fri Jul 17 2015 Nick Markowski <nmarkowski@keywcorp.com> - 5.0.0-0
- Refactored module to new layout, to better conform with Puppetlabs.
- Vsftpd user and group mutable.
- Package requires user and group to be set before installation.

* Thu Feb 19 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-8
- Migrated to the new 'simp' environment.

* Fri Jan 16 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-7
- Changed puppet-server requirement to puppet

* Wed Oct 22 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-6
- Update to account for the stunnel module updates in 4.2.0-0

* Fri Oct 17 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-5
- CVE-2014-3566: Updated protocols to mitigate POODLE.

* Tue Sep 16 2014 Nick Markowski <nmarkowski@keywcorp.com> - 4.1.0-4
- Updated the module to be compatible with RHEL6 and RHEL7.

* Fri Jul 25 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-3
- Changed ip_conntrack_ftp to nf_conntrack_ftp to properly load the
  kernel module and not restart iptables every time Puppet runs.

* Sun Jun 22 2014 Kendall Moore <kmoore@keywcorp.com> - 4.1.0-2
- Removed MD5 file checksums for FIPS compliance.

* Thu Apr 03 2014 Nick Markowski <nmarkowski@keywcorp.com> - 4.1.0-1
- Updated module for puppet3/hiera and added lint and rspec tests.
- Copied pki to /etc/vsftpd/pki

* Thu Feb 13 2014 Kendall Moore <kmoore@keywcorp.com> 4.1.0-0
- Update to remove warnings about IPTables not being detected. This is a
  nuisance when allowing other applications to manage iptables legitimately.
- Converted all string booleans to native booleans.

* Tue Oct 08 2013 Kendall Moore <kmoore@keywcorp.com> 2.0.0-9
- Updated all erb templates to properly scope variables.

* Tue Feb 05 2013 Maintenance
2.0.0-8
- Edited init.pp from "checksum => 'undef'" to "checksum => undef".

* Thu Jan 31 2013 Maintenance
2.0.0-7
- Created Cucumber tests to setup and configure a vsftpd server and check to make sure
  that the vsftpd service can run successfully.

* Thu Dec 13 2012 Maintenance
2.0.0-6
- Updated to require pupmod-common >= 2.1.1-2 so that upgrading an old
  system works properly.

* Wed Apr 11 2012 Maintenance
2.0.0-5
- Moved mit-tests to /usr/share/simp...
- Updated pp files to better meet Puppet's recommended style guide.

* Fri Mar 02 2012 Maintenance
2.0.0-4
- Improved test stubs.

* Mon Dec 26 2011 Maintenance
2.0.0-3
- Updated the spec file to not require a separate file list.

* Mon Oct 10 2011 Maintenance
2.0.0-2
- Updated to put quotes around everything that need it in a comparison
  statement so that puppet > 2.5 doesn't explode with an undef error.

* Mon Apr 18 2011 Maintenance - 2.0.0-1
- Changed puppet://$puppet_server/ to puppet:///
- vsftpd::conf is now in its own file.
- Added comments so that users know to restart vsftpd if they use alternate
  certificates.
- Restart vsftpd if any part of the default certs change.
- Changed all instances of defined(Class['foo']) to defined('foo') per the
  directions from the Puppet mailing list.

* Tue Jan 11 2011 Maintenance
2.0.0-0
- Refactored for SIMP-2.0.0-alpha release

* Tue Oct 26 2010 Maintenance - 1-2
- Converting all spec files to check for directories prior to copy.

* Thu Sep 09 2010 Maintenance
1.0-1
- Replaced tcpwrappers::tcpwrappers_allow with tcpwrappers::allow.

* Mon May 24 2010 Maintenance
1.0-0
- Code refactoring.

* Tue Sep 29 2009 Maintenance
0.1-0
- Initial configuration module
