# AGENTS.md

This file provides guidance to AI agents when working with code in this repository.

## What this module does

`simp-vsftpd` is a SIMP Puppet module that installs, configures, and runs the
**vsftpd FTP server** with SIMP hardening. The public `vsftpd` class is a thin
orchestrator that `include`s four private worker classes in a strict order and
wires the optional feature integrations (`manifests/init.pp:105-121`):

```
vsftpd::users -> vsftpd::install -> vsftpd::config ~> vsftpd::service -> vsftpd
```

(`manifests/init.pp:110-114` — note the `~>` notify edge from `config` to
`service` so a config change restarts the daemon.)

- **`vsftpd::users`** (`manifests/users.pp`) — manages the `ftp` group/user
  (defaults gid `50` / uid `14`, home `/var/ftp`, shell `/sbin/nologin`),
  each gated by `$manage_group` / `$manage_user` (`users.pp:8-26`).
- **`vsftpd::install`** (`manifests/install.pp`) — `package { 'vsftpd' }` at
  `$vsftpd::package_ensure` (`install.pp:9-11`).
- **`vsftpd::config`** (`manifests/config.pp`) — the bulk of the logic: renders
  `/etc/vsftpd/vsftpd.conf` from `templates/vsftpd.conf.erb`, manages the FTP
  user allow-list file (default `/etc/vsftpd/user_list`) from
  `templates/user_list.erb`, ships static `files/ftpusers` and `files/vsftpd.pam`,
  manages the `/etc/vsftpd` directory (recursive+purge), optionally copies TLS
  certs via `pki::copy`, and manages `/etc/ftpusers` with the `ftpusers` type
  (`config.pp:175-243`).
- **`vsftpd::service`** (`manifests/service.pp`) — `service { 'vsftpd' }`
  running+enabled (`service.pp:8-13`).

Two optional integrations are pulled in from `init.pp` only when their toggle is
true: `vsftpd::config::firewall` (`init.pp:116-118`) and
`vsftpd::config::tcpwrappers` (`init.pp:119-121`).

### FTPS / TLS

TLS is central to this module's hardening posture. **Local users are forced to
SSL for security reasons** (per the class docstring, `init.pp:60-61`):
`$force_local_data_ssl` and `$force_local_logins_ssl` both default to `true`
(`config.pp:66-67`), and `$ssl_enable` defaults to `true` (`init.pp:86`). Only
TLSv1.2 is on by default — `$ssl_tlsv1_2 = true`, while SSLv2/SSLv3/TLSv1/TLSv1.1
are all `false` (`config.pp:88-92`). The OpenSSL cipher suite comes from
`simp_options::openssl::cipher_suite` (default `['DEFAULT','!MEDIUM']`,
`init.pp:72`) and is joined with `:` in the template
(`templates/vsftpd.conf.erb:27`). Cert paths default under
`/etc/pki/simp_apps/vsftpd/x509` keyed on the node FQDN (`config.pp:136-139`).

## Gotchas / non-obvious details

- **The four worker classes are private; consumers use `include 'vsftpd'`.**
  `vsftpd::install`, `vsftpd::config`, `vsftpd::service`,
  `vsftpd::config::tcpwrappers`, and `vsftpd::config::firewall` each call
  `assert_private()` (`install.pp:7`, `config.pp:148`, `service.pp:6`,
  `config/tcpwrappers.pp:6`, `config/firewall.pp:12`), as does `vsftpd::users`
  (`users.pp:6`) — 6 `assert_private()` sites in all. Only `vsftpd` (init.pp) is
  public.
- **Each optional integration is double-gated.** Every optional dependency is
  declared optional in `metadata.json` (`simp.optional_dependencies`) and is
  asserted with `simplib::assert_optional_dependency` *only when its feature
  toggle is on* — never hard-`include`d unconditionally. The four assert sites:
  - `simp/haveged` — `init.pp:100`, inside `if $haveged and $ssl_enable`
    (`init.pp:99`).
  - `simp/iptables` — `config/firewall.pp:16`, inside `if $vsftpd::listen_ipv4`
    (`config/firewall.pp:15`); the firewall class itself is only included when
    `$firewall` is true (`init.pp:116`).
  - `simp/tcpwrappers` — `config/tcpwrappers.pp:8`; the class is only included
    when `$tcpwrappers` is true (`init.pp:119`).
  - `simp/pki` — `config.pp:176`, inside `if $::vsftpd::pki` (`config.pp:175`).
- **`$pki` is tri-state, not boolean.** `Variant[Enum['simp'],Boolean]`
  (`init.pp:68`): `'simp'` includes SIMP's pki module and copies certs via
  `pki::copy`; `true` copies certs via `pki::copy` *without* including pki;
  `false` does neither and you must set `app_pki_*` yourself
  (`config.pp:4-15`).
- **`haveged` entropy is only pulled in when SSL is also enabled** — the guard is
  `if $haveged and $ssl_enable` (`init.pp:99`), because the entropy is for TLS.
- **`listen_ipv4` and `config::listen_ipv6` are mutually exclusive** — setting
  both `fail()`s at compile time (`config.pp:150-152`; note the `exculsive`
  typo in the message, left as-is).
- **`/etc/vsftpd` is managed `recurse => true, purge => true`**
  (`config.pp:186-195`) — unmanaged files placed there will be removed on the
  next run.
- **Passive-mode firewall rules need both min and max ports.** In the firewall
  class, if only one of `pasv_min_port` / `pasv_max_port` is set it `fail()`s
  (`config/firewall.pp:37-39`); when both are set it opens the range and sets
  `net.netfilter.nf_conntrack_helper=1` via sysctl (`config/firewall.pp:41-44`).
  The firewall class is IPv4-only (`# TODO support ipv6`, `config/firewall.pp:14`).
- **The user allow-list semantics are inverted by default.** `$userlist_deny`
  defaults to `true` (`init.pp:88`), so the users listed in `user_list.erb`
  (the `$user_list` array, default `root bin daemon ... nobody`, `init.pp:90`)
  are the users *denied* access — see the header comment in
  `templates/user_list.erb:1-6`.
- **`/etc/ftpusers` is managed only when `$min_uid` is non-empty**
  (`config.pp:231`, default `'500'`); the `ftpusers` type prunes users below
  `min_id` from that file (`config.pp:239-242`).
- **`simp/simp_options` is NOT a declared dependency** in `metadata.json`, yet
  the manifests consume the `simp_options::*` seam via `simplib::lookup`
  (the lookup function is provided by `simp/simplib`).

## The `simp_options` / `simplib::lookup` seam

The module routes all SIMP feature toggles through `simplib::lookup(...,
{ 'default_value' => ... })` with an explicit default rather than assuming
`simp_options` is included:

| Line | Key | `default_value` |
|------|-----|-----------------|
| `init.pp:67` | `simp_options::firewall` | `false` |
| `init.pp:68` | `simp_options::pki` | `false` |
| `init.pp:69` | `simp_options::tcpwrappers` | `false` |
| `init.pp:70` | `simp_options::trusted_nets` | `['127.0.0.1','::1']` |
| `init.pp:71` | `simp_options::haveged` | `false` |
| `init.pp:72` | `simp_options::openssl::cipher_suite` | `['DEFAULT','!MEDIUM']` |
| `init.pp:73` | `simp_options::package_ensure` | `'installed'` |
| `config.pp:135` | `simp_options::pki::source` | `'/etc/pki/simp/x509'` |

Keep adding new SIMP toggles this way — with an explicit default — rather than
assuming `simp_options` is in the catalog.

## Dependencies

Module dependencies (from `metadata.json`):

- `simp/simplib` `>= 4.9.0 < 6.0.0` — provides `simplib::lookup`,
  `simplib::assert_optional_dependency`, the `Simplib::*` data types
  (`Netlist`, `Port`, `IP::V4`, `IP::V6`, `Host`, `Umask`) used across the
  manifests, and the `ftpusers` type used in `config.pp:239`.
- `puppetlabs/stdlib` `>= 8.0.0 < 10.0.0` — provides the `Stdlib::Absolutepath`
  type and `empty()`.

Optional dependencies (from `metadata.json` `simp.optional_dependencies`), each
used only when the corresponding feature toggle is on (see Gotchas):

- `simp/haveged` `>= 0.4.5 < 1.0.0` — entropy generation for TLS.
- `simp/iptables` `>= 6.5.3 < 9.0.0` — firewall rules
  (`iptables::listen::tcp_stateful`).
- `simp/pki` `>= 6.2.0 < 8.0.0` — TLS cert distribution via `pki::copy`.
- `simp/tcpwrappers` `>= 6.2.0 < 7.0.0` — TCP Wrappers access control.

Runtime requirement (from `metadata.json` `requirements`): `openvox
>= 8.0.0 < 9.0.0`. This module has migrated its runtime baseline to **OpenVox**.
The `Gemfile` reflects the transition: its default version range is `['>= 8',
'< 9']` (`Gemfile:23`), and it installs **both** the `openvox` and `puppet`
gems via ``['openvox', 'puppet'].each do |gem_name|`` (`Gemfile:30`) — a
transitional shim kept until the `puppet` dependency is dropped from other gems.

Supported OS matrix (from `metadata.json`): CentOS 9/10; RedHat 8/9/10;
OracleLinux 8/9/10; Rocky 8/9/10; AlmaLinux 8/9/10.

## Repository layout

- `manifests/init.pp` — the public `vsftpd` class: parameters, the
  `simp_options` seam, the ordered `include`s, and the optional-integration
  toggles.
- `manifests/install.pp` — `vsftpd::install` (the `vsftpd` package).
- `manifests/config.pp` — `vsftpd::config`: `vsftpd.conf`, the user allow-list,
  static `ftpusers`/PAM files, the `/etc/vsftpd` dir, `pki::copy`, and
  `/etc/ftpusers` management. Carries most vsftpd.conf-facing parameters.
- `manifests/config/firewall.pp` — `vsftpd::config::firewall` (optional
  iptables rules; IPv4 only).
- `manifests/config/tcpwrappers.pp` — `vsftpd::config::tcpwrappers` (optional
  TCP Wrappers allow rule).
- `manifests/service.pp` — `vsftpd::service` (the `vsftpd` service).
- `manifests/users.pp` — `vsftpd::users` (the `ftp` group/user).
- `templates/vsftpd.conf.erb` — the main `/etc/vsftpd/vsftpd.conf` template
  (boolean values are rendered YES/NO; most options emit only when non-nil).
- `templates/user_list.erb` — the FTP user allow/deny list (iterates
  `@_user_list`).
- `files/ftpusers`, `files/vsftpd.pam` — static payloads served via
  `puppet:///modules/vsftpd/...` (`config.pp:201,219`).
- `metadata.json` — deps, optional deps, OS matrix, OpenVox requirement.
- `spec/classes/init_spec.rb`, `spec/classes/config_spec.rb` — rspec-puppet
  unit tests.
- `spec/acceptance/suites/default/` — three beaker suites: `00_default_spec.rb`,
  `05_ftp_connection_spec.rb`, `10_ftp_tls_connection_spec.rb`.
- `spec/acceptance/nodesets/` — 16 beaker nodesets (`default.yml` plus one per
  supported OS/major: almalinux 8/9/10, centos 9/10 + `centos.yml`, oel 8/9/10,
  rhel 8/9/10, rocky 8/9/10).
- `REFERENCE.md` — generated Puppet Strings reference.
- No `types/`, `lib/`, `data/`, or `hiera.yaml` — this module ships no custom
  data types, Ruby types/providers/functions/facts, and no in-module Hiera data.
  Every custom type, fact, and function it uses comes from the dependencies
  above.

### CI

`.github/workflows/pr_tests.yml` runs on pull requests. There are six
lint/unit jobs plus a live acceptance job:

- `puppet-syntax` (`bundle exec rake syntax`)
- `puppet-style` (`bundle exec rake lint` + `rake metadata_lint`)
- `ruby-style` (`bundle exec rake rubocop`, `continue-on-error`)
- `file-checks` (`rake check:dot_underscore`, `rake check:test_file`)
- `releng-checks` (version/tag/changelog checks + `pdk build --force`)
- `spec-tests` (`bundle exec rake parallel_spec`, Puppet 8.x / Ruby 3.2)
- **`acceptance`** — an **active** beaker job. Matrix nodes `almalinux9` and
  `almalinux10` (`pr_tests.yml:122-123`); the final step runs
  `bundle exec rake beaker:suites[default,<node>]` under
  `BEAKER_HYPERVISOR: 'vagrant_libvirt'` (`pr_tests.yml:143`), after installing
  vagrant-libvirt + qemu on the runner.

## Common commands

```sh
# Install dependencies
bundle install

# Run all unit tests
bundle exec rake spec

# Run a single class spec
bundle exec rspec spec/classes/init_spec.rb

# Puppet lint
bundle exec rake lint

# Ruby lint
bundle exec rake rubocop

# Regenerate REFERENCE.md from puppet-strings docstrings
puppet strings generate --format markdown --out REFERENCE.md

# Run a beaker acceptance suite (default suite, default nodeset)
bundle exec rake beaker:suites[default]
```

Relevant gem pins (from `Gemfile`): `rubocop ~> 1.88.0` (`Gemfile:16`),
`puppetlabs_spec_helper ~> 8.0.0` (`Gemfile:33`), `simp-rake-helpers ~> 5.24.0`
(`Gemfile:39`), `simp-beaker-helpers ~> 2.0.0` (`Gemfile:56`). The default
Puppet/OpenVox test range is `['>= 8', '< 9']` (`Gemfile:23`).

## Conventions

- **`init.pp` is the only public class; keep the workers private.** New logic in
  `install`/`config`/`service`/`users`/`config::*` must keep its
  `assert_private()` guard.
- **Route SIMP feature toggles through
  `simplib::lookup('simp_options::*', { 'default_value' => ... })`** with an
  explicit default rather than assuming `simp_options` is included.
- **Guard every optional integration** (`haveged`, `iptables`, `pki`,
  `tcpwrappers`) with `simplib::assert_optional_dependency` behind its feature
  toggle — declare it in `metadata.json` `simp.optional_dependencies`, never
  hard-`include` it unconditionally.
- **Keep vsftpd.conf options driven from the ERB template.** Most options emit
  only when their variable is non-nil; preserve the YES/NO boolean translation
  and the `Optional[...]` parameter typing so unset options stay out of the
  rendered config.
- Preserve the `@summary` / `@param` puppet-strings docstrings on the classes —
  they drive `REFERENCE.md`. Regenerate `REFERENCE.md` after changing docs or
  parameters.
- `Gemfile`, `spec/spec_helper.rb`, and `.github/workflows/pr_tests.yml` carry a
  **puppetsync** notice — they are baseline-managed and the next sync overwrites
  local edits. Push changes to those files upstream to the baseline, not here.
- Match the existing 2-space Puppet indentation and aligned-arrow parameter
  style used throughout `manifests/`.
