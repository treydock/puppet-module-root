# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v6.1.0](https://github.com/treydock/puppet-module-root/tree/v6.1.0) (2023-06-16)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v6.0.0...v6.1.0)

### Added

- Note compatibility with stdlib 9.x [\#28](https://github.com/treydock/puppet-module-root/pull/28) ([jcpunk](https://github.com/jcpunk))

## [v6.0.0](https://github.com/treydock/puppet-module-root/tree/v6.0.0) (2023-05-01)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v5.1.2...v6.0.0)

### Changed

- BREAKING CHANGE: Remove Hiera merge parameters [\#26](https://github.com/treydock/puppet-module-root/pull/26) ([treydock](https://github.com/treydock))
- Support Puppet 8, drop Puppet 6 and Ubuntu 18.04 [\#25](https://github.com/treydock/puppet-module-root/pull/25) ([treydock](https://github.com/treydock))
- Support more root key types, replace root\_sshrsakey fact with root\_ssh\_key.rsa [\#24](https://github.com/treydock/puppet-module-root/pull/24) ([treydock](https://github.com/treydock))
- Drop Debian 9 support [\#22](https://github.com/treydock/puppet-module-root/pull/22) ([treydock](https://github.com/treydock))

### Added

- Support EL9 and Ubuntu 22.04 [\#23](https://github.com/treydock/puppet-module-root/pull/23) ([treydock](https://github.com/treydock))
- Modernize unit testing [\#21](https://github.com/treydock/puppet-module-root/pull/21) ([treydock](https://github.com/treydock))

## [v5.1.2](https://github.com/treydock/puppet-module-root/tree/v5.1.2) (2022-06-21)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v5.1.1...v5.1.2)

### Fixed

- Set show\_diff to false for SSH public and private keys [\#18](https://github.com/treydock/puppet-module-root/pull/18) ([treydock](https://github.com/treydock))

## [v5.1.1](https://github.com/treydock/puppet-module-root/tree/v5.1.1) (2022-06-06)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v5.1.0...v5.1.1)

### Fixed

- Make sure file ends in new line [\#17](https://github.com/treydock/puppet-module-root/pull/17) ([jcpunk](https://github.com/jcpunk))

## [v5.1.0](https://github.com/treydock/puppet-module-root/tree/v5.1.0) (2022-05-17)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v5.0.0...v5.1.0)

### Added

- Support Debian and Ubuntu [\#16](https://github.com/treydock/puppet-module-root/pull/16) ([treydock](https://github.com/treydock))
- Make password Sensitive [\#14](https://github.com/treydock/puppet-module-root/pull/14) ([jcpunk](https://github.com/jcpunk))

## [v5.0.0](https://github.com/treydock/puppet-module-root/tree/v5.0.0) (2022-03-15)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v4.6.0...v5.0.0)

### Changed

- Major updates \(Read description\) [\#13](https://github.com/treydock/puppet-module-root/pull/13) ([treydock](https://github.com/treydock))

## [v4.6.0](https://github.com/treydock/puppet-module-root/tree/v4.6.0) (2020-10-26)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v4.5.0...v4.6.0)

### Added

- Add booleans for hiera merge [\#11](https://github.com/treydock/puppet-module-root/pull/11) ([jcpunk](https://github.com/jcpunk))

## [v4.5.0](https://github.com/treydock/puppet-module-root/tree/v4.5.0) (2020-10-21)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v4.4.0...v4.5.0)

### Added

- Add optional root shell timeout [\#10](https://github.com/treydock/puppet-module-root/pull/10) ([jcpunk](https://github.com/jcpunk))

## [v4.4.0](https://github.com/treydock/puppet-module-root/tree/v4.4.0) (2020-09-18)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v4.3.0...v4.4.0)

### Added

- Support defining /root/.k5login and /root/.k5users [\#9](https://github.com/treydock/puppet-module-root/pull/9) ([treydock](https://github.com/treydock))

## [v4.3.0](https://github.com/treydock/puppet-module-root/tree/v4.3.0) (2020-05-12)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v4.2.0...v4.3.0)

### Added

- Update stdlib dependency range and PDK update [\#6](https://github.com/treydock/puppet-module-root/pull/6) ([treydock](https://github.com/treydock))

## [v4.2.0](https://github.com/treydock/puppet-module-root/tree/v4.2.0) (2019-10-03)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v4.1.1...v4.2.0)

### Added

- Add export\_key\_options parameter [\#3](https://github.com/treydock/puppet-module-root/pull/3) ([treydock](https://github.com/treydock))

## [v4.1.1](https://github.com/treydock/puppet-module-root/tree/v4.1.1) (2019-05-09)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v4.1.0...v4.1.1)

### Added

- Convert module to PDK [\#1](https://github.com/treydock/puppet-module-root/pull/1) ([treydock](https://github.com/treydock))

### Fixed

- Fix dependency cycle [\#2](https://github.com/treydock/puppet-module-root/pull/2) ([treydock](https://github.com/treydock))

## [v4.1.0](https://github.com/treydock/puppet-module-root/tree/v4.1.0) (2019-05-07)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/4.0.0...v4.1.0)

## [4.0.0](https://github.com/treydock/puppet-module-root/tree/4.0.0) (2019-03-22)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/3.0.0...4.0.0)

## [3.0.0](https://github.com/treydock/puppet-module-root/tree/3.0.0) (2017-10-26)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/2.0.0...3.0.0)

## [2.0.0](https://github.com/treydock/puppet-module-root/tree/2.0.0) (2017-10-26)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/1.0.0...2.0.0)

## [1.0.0](https://github.com/treydock/puppet-module-root/tree/1.0.0) (2014-05-09)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v0.0.3...1.0.0)

## [v0.0.3](https://github.com/treydock/puppet-module-root/tree/v0.0.3) (2013-06-12)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v0.0.2...v0.0.3)

## [v0.0.2](https://github.com/treydock/puppet-module-root/tree/v0.0.2) (2013-05-14)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/v0.0.1...v0.0.2)

## [v0.0.1](https://github.com/treydock/puppet-module-root/tree/v0.0.1) (2013-05-14)

[Full Changelog](https://github.com/treydock/puppet-module-root/compare/c5c86cb5c420afe804a18e68f626a44d111af4e4...v0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
