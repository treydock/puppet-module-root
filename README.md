# puppet-root

[![Build Status](https://travis-ci.org/treydock/puppet-module-root.svg?branch=master)](https://travis-ci.org/treydock/puppet-module-root)

####Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Overview

This module manages the Linux root user.

## Usage

### root

    include ::root

Manage root and define mailaliases, ssh\_authorized\_keys and set a password.

    root::mailaliases:
      - 'root@example.com'
    root::password: '$1$Bp8B.dWo$DUVekjsAsU0ttWZmS37P5'
    root::ssh_authorized_keys:
      - 'ssh-rsa somelonghash== user@fqdn'

Authorized keys can also be set using a hash.

    root::ssh_authorized_keys:
      user@fqdn:
        type: 'ssh-rsa'
        key: 'somelonghash=='

To export a system's root RSA key

    root::export_key: true

To collect exported root RSA keys from multiple tags

    root::collect_exported_keys: true
    root::collect_exported_keys_tags:
      - "${::domain}"
      - 'foo'

## Reference

### Classes

#### Public classes

* `root`: Installs and configures root.

#### Private classes

* `root::rsakey::export`: Exports root's RSA key
* `root::params`: Sets module default values.

### Parameters

#### root

#####`mailaliases`

An array that defines mailaliases for the root user (defaults to an empty array).

When an empty array is given Mailaliases[root] is set to `ensure => absent`.

#####`mailaliases_hiera_merge`

Boolean that determines if the hiera_hash function will be used to merge `root::mailaliases` values from hiera data.

Default value is `true`.

#####`ssh_authorized_keys`

Defines ssh\_autorized\_keys to be passed to the `root::ssh_authorized_key` defined type.  An array or hash can be given.

If the value is an Array, it must take the form 

#####`ssh_authorized_keys_hiera_merge`

Boolean that determines if the hiera_hash function will be used to merge `root::ssh_authorized_keys` values from hiera data.

Default value is `true`.

#####`password`

The password hash used for the root account.  Default value is `undef`.

#####`purge_ssh_keys`

Boolean.  Sets if unmanaged SSH keys will be purged for the root account.  Default value is `true`.

#####`export_key`

Boolean.  Sets if the root SSH RSA key should be created and exported.  Default value is `false`.

#####`export_key_tag`

The tag to use when exporting the root SSH RSA key.  Default value is `$::domain`.

#####`collect_exported_keys`

Boolean.  Sets if the export root SSH RSA keys should be collected.  Default value is `false`.

#####`collect_exported_keys_tags`

Array of tags for root SSH RSA keys to collect.  Default value is `[$::domain]`.

### Defines

#### root::ssh\_authorized\_key

Used to define root authorized SSH keys.

All parameters are passed to root's ssh\_authorized\_key type.

#### root::rsakey::collect

This is a private defined type.

## Limitations

This module has been tested on:

* CentOS 6 x86_64
* CentOS 7 x86_64
* Scientific Linux 6 x86_64

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

