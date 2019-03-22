# puppet-root

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/root.svg)](https://forge.puppetlabs.com/treydock/root)
[![Build Status](https://travis-ci.org/treydock/puppet-module-root.svg?branch=master)](https://travis-ci.org/treydock/puppet-module-root)

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Overview

This module manages the Linux root user.

Puppet 6 has soft dependencies on the following modules:

* [puppetlabs/mailalias_core](https://forge.puppet.com/puppetlabs/mailalias_core)
* [puppetlabs/sshkeys_core](https://forge.puppet.com/puppetlabs/sshkeys_core)

## Usage

### root

```puppet
include ::root
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

To export a system's root RSA key

```yaml
root::export_key: true
```

To collect exported root RSA keys from multiple tags

```yaml
root::collect_exported_keys: true
root::collect_exported_keys_tags:
  - "${::domain}"
  - 'foo'
```

## Reference

[http://treydock.github.io/puppet-module-root/](http://treydock.github.io/puppet-module-root/)

## Limitations

This module has been tested on:

* RedHat & CentOS 6 x86_64
* RedHat & CentOS 7 x86_64

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake acceptance

