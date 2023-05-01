# puppet-module-root

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/root.svg)](https://forge.puppetlabs.com/treydock/root)
[![CI Status](https://github.com/treydock/puppet-module-root/workflows/CI/badge.svg?branch=master)](https://github.com/treydock/puppet-module-root/actions?query=workflow%3ACI)

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)

## Overview

This module manages the Linux root user.

This module has soft dependencies on the following modules:

* [puppetlabs/mailalias_core](https://forge.puppet.com/puppetlabs/mailalias_core)
* [puppetlabs/sshkeys_core](https://forge.puppet.com/puppetlabs/sshkeys_core)

## Usage

### root

```puppet
include root
```

Manage root and define mailaliases, ssh\_authorized\_keys and set a password.

```yaml
root::mailaliases:
  - 'root@example.com'
root::password: '$1$Bp8B.dWo$DUVekjsAsU0ttWZmS37P5'
root::ssh_authorized_keys:
  - 'ssh-rsa somelonghash== user@fqdn'
```

Authorized keys can also be set using a hash.

```yaml
root::ssh_authorized_keys:
  user@fqdn:
    type: 'ssh-rsa'
    key: 'somelonghash=='
```

If you wish to merge authorized keys from multiple locations:

```yaml
lookup_options:
  root::mailaliases:
    merge: unique
  root::ssh_authorized_keys:
    merge: deep
root::mailaliases:
  - 'root@example.com'
root::ssh_authorized_keys:
  user@fqdn:
    type: 'ssh-rsa'
    key: 'somelonghash=='
# Some other Hiera location:
root::mailaliases:
  - 'root@example2.com'
root::ssh_authorized_keys:
  user2@fqdn:
    type: 'ssh-rsa'
    key: 'somelonghash=='
```

If you use Arrays for resources like `root::ssh_authorized_keys` then use `unique` merge instead of `deep`.

To export a system's root RSA key

```yaml
root::export_key: true
```

To generate and export a different root SSH key:

```yaml
root::generate_key_type: ecdsa-sk
root::export_key_type: "%{lookup('root::generate_key_type')}"
```

To collect exported root RSA keys from multiple tags

```yaml
root::collect_exported_keys: true
root::collect_exported_keys_tags:
  - "%{facts.domain}"
  - 'foo'
```

Add Kerberos principals to `/root/.k5login`:

```yaml
root::kerberos_login_principals:
  - user1@EXAMPLE.COM
  - user2@EXAMPLE.COM
```

Add Kerberos principals and commands to `/root/.k5users`. Note that user3 and user4 will not have commands defined.  The examples also illustrate defining commands as strings or arrays.

```yaml
root::kerberos_users_commands:
  user1@EXAMPLE.COM:
    - /bin/systemctl
    - /bin/cat
  user2@EXAMPLE.COM: /bin/systemctl /bin/cat
  user3@EXAMPLE.COM: ''
  user4@EXAMPLE.COM: []
```

If a different module manages Kerberos for root, disable Kerberos in this module:

```yaml
root::manage_kerberos: false
```

Set an automatic logout for idle interactive shells (in seconds):

```yaml
root::logout_timeout: 600
```

## Reference

[http://treydock.github.io/puppet-module-root/](http://treydock.github.io/puppet-module-root/)
