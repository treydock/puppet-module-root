# puppet-root

[![Build Status](https://travis-ci.org/treydock/puppet-root.svg?branch=master)](https://travis-ci.org/treydock/puppet-root)

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

Manage root and define mailaliases, ssh_authorized_keys and set a password.

    class { 'root':
      mailaliases         => ['root@example.com'],
      password            => '$1$Bp8B.dWo$DUVekjsAsU0ttWZmS37P5',
      ssh_authorized_keys => [
        'ssh-rsa somelonghash== user@fqdn',
      ],
    }

## Reference

### Classes

#### Public classes

* `root`: Installs and configures root.

#### Private classes

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

Defines ssh\_autorized\_keys to be passed to the `root::ssh_authorized_keys` defined type.  An array or hash can be given.

If the value is an Array, it must take the form 

#####`ssh_authorized_keys_hiera_merge`

Boolean that determines if the hiera_hash function will be used to merge `root::ssh_authorized_keys` values from hiera data.

Default value is `true`.

#####`password`

The password hash used for the root account.  Default value is `undef`.

#####`purge_ssh_keys`

Boolean.  Sets if unmanaged SSH keys will be purged for the root account.  Default value is `true`.

### Defines

#### root::ssh\_authorized\_keys

TODO

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

