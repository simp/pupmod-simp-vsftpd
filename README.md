[![License](https://img.shields.io/:license-apache-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/73/badge)](https://bestpractices.coreinfrastructure.org/projects/73)
[![Puppet Forge](https://img.shields.io/puppetforge/v/simp/vsftpd.svg)](https://forge.puppetlabs.com/simp/vsftpd)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/simp/vsftpd.svg)](https://forge.puppetlabs.com/simp/vsftpd)
[![Build Status](https://travis-ci.org/simp/pupmod-simp-vsftpd.svg)](https://travis-ci.org/simp/pupmod-simp-vsftpd)

#### Table of Contents

<!-- vim-markdown-toc GFM -->

* [Overview](#overview)
* [This is a SIMP module](#this-is-a-simp-module)
* [Module Description](#module-description)
* [Usage](#usage)
  * [A Basic Anonymous FTP Server](#a-basic-anonymous-ftp-server)
  * [A TLS Protected FTP Server with Local Accounts](#a-tls-protected-ftp-server-with-local-accounts)
* [Development](#development)
  * [Acceptance tests](#acceptance-tests)

<!-- vim-markdown-toc -->

## Overview

This module manages [vsftpd](https://security.appspot.com/vsftpd.html) on
supported systems.

## This is a SIMP module

This module is a component of the [System Integrity Management Platform](https://simp-project.com),
a compliance-management framework built on Puppet.

If you find any issues, they can be submitted to our [JIRA](https://simp-project.atlassian.net/).

This module is optimally designed for use within a larger SIMP ecosystem, but it can be used independently:
* When included within the SIMP ecosystem, security compliance settings will be
  managed from the Puppet server.
* If used independently, all SIMP-managed security subsystems will be disabled by
  default and must be explicitly opted into by administrators.  Please review
  ``simp_options`` for details.

## Module Description

This module can be used for the configuration of vsftpd and includes support for
setting up TLS protected servers.

## Usage

### A Basic Anonymous FTP Server

```puppet
# If you're not using the SIMP iptables module, you'll need to make sure the
# PASV ports are accessiable using your preferred method.

class { 'vsftpd':
  ssl_enable    => false,
  pasv_min_port => 10000,
  pasv_max_port => 20000
}
```

### A TLS Protected FTP Server with Local Accounts

```puppet
# If you're not using the SIMP iptables module, you'll need to make sure the
# PASV ports are accessiable using your preferred method.

# If you decide not to use the SIMP PKI module, you'll need to manage the
# certificate locations on the filesystem yourself using the options in
# vsftpd::config

# You may need to flip one or more SELinux booleans depending on your setup.
# This really depends on your system so it cannot be automated cleanly.

class { 'vsftpd':
  local_enable  => true,
  ssl_enable    => true,
  pasv_min_port => 10000,
  pasv_max_port => 20000
}
```

## Development

Please read our [Contribution Guide](https://simp.readthedocs.io/en/stable/contributors_guide/Contribution_Procedure.html)

### Acceptance tests

This module includes [Beaker](https://github.com/puppetlabs/beaker) acceptance
tests using the SIMP [Beaker Helpers](https://github.com/simp/rubygem-simp-beaker-helpers).
By default the tests use [Vagrant](https://www.vagrantup.com/) with
[VirtualBox](https://www.virtualbox.org) as a back-end; Vagrant and VirtualBox
must both be installed to run these tests without modification. To execute the
tests run the following:

```shell
bundle exec rake beaker:suites
```

Some environment variables may be useful:

```shell
BEAKER_debug=true
BEAKER_provision=no
BEAKER_destroy=no
BEAKER_use_fixtures_dir_for_modules=yes
BEAKER_fips=yes
```

* `BEAKER_debug`: show the commands being run on the STU and their output.
* `BEAKER_destroy=no`: prevent the machine destruction after the tests finish so you can inspect the state.
* `BEAKER_provision=no`: prevent the machine from being recreated. This can save a lot of time while you're writing the tests.
* `BEAKER_use_fixtures_dir_for_modules=yes`: cause all module dependencies to be loaded from the `spec/fixtures/modules` directory, based on the contents of `.fixtures.yml`.  The contents of this directory are usually populated by `bundle exec rake spec_prep`.  This can be used to run acceptance tests to run on isolated networks.
* `BEAKER_fips=yes`: enable FIPS-mode on the virtual instances. This can
  take a very long time, because it must enable FIPS in the kernel
  command-line, rebuild the initramfs, then reboot.

Please refer to the [SIMP Beaker Helpers documentation](https://github.com/simp/rubygem-simp-beaker-helpers/blob/master/README.md)
for more information.
