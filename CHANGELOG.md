## treydock-root changelog

Release notes for the treydock-root module.

------------------------------------------

#### 2.0.0 - 2017-10-26

This release introduces new features that are not backwards compatible with the previous release.

Changes:

* Allow root SSH RSA key to be exported and collected
  * Add `export_key` parameter
  * Add `export_key_tag` parameter
  * Add `collect_exported_keys` parameter
  * Add `collect_exported_keys_tags` parameter
  * Add `root_sshrsakey` fact
* Rename `authorized_keys` parameter to `ssh_authorized_keys`
* Add `ssh_authorized_keys_hiera_merge` parameter
* Add `mailalias_hiera_merge` parameter
* Manage /root/.ssh/id_rsa if `ssh_private_key_source` parameter is set
* Manage /root/.ssh/id_rsa.pub if `ssh_public_key_source` parameter is set
* Change hiera lookup for ssh\_authorized\_keys to use the `root::ssh_authorized_keys` key
* Change hiera lookup for mailaliases to use the `root::mailaliases` key
* Manage root user
* Add `password` and `purge_ssh_keys` parameters that directly modify the User[root] resource
* Use hiera functions to collect mailaliases and ssh\_authorized\_keys for root
* Add Define[root::ssh\_authorized\_keys] to manage Ssh\_authorized\_keys for root user
* No longer use template to manage root user's .ssh/authorized_keys contents
* Update development dependencies
* Add LICENSE

------------------------------------------

#### 1.0.0 - 2014-05-09

* Add mailaliases parameter to optionally set mail addresses for root user
* Always manage root's authorized_keys, even if the authorized_keys parameter is empty
* Replace rspec-system with beaker-rspec for system testing
* Use more up-to-date gems and Rake tasks for more thorough unit testing
