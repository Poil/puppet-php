# == Class php::repo
class php::repo (
  $repo = 'distrib'
) {
  case $::operatingsystem {
    'Ubuntu': {
      case $repo {
        'distrib': {
          class { '::php::repo::ubuntu' : ensure => absent }
        }
        'ondrej': {
          class { '::php::repo::ubuntu' : ensure => present }
        }
        default : {
          fail("error - ${module_name} : unknown repository ${repo} for ${::operatingsystem}")
        }
      }
    }
    'Debian': {
      case $repo {
        'distrib': {
          class { '::php::repo::debian' : ensure => absent }
        }
        'dotdeb': {
          class { '::php::repo::debian' : ensure => present }
        }
        'sury': {
          class { '::php::repo::debian' : ensure => present }
        }
        default : {
          fail("error - ${module_name} : unknown repository ${repo} for ${::operatingsystem}")
        }
      }
    }
    'RedHat', 'CentOS', 'OracleLinux': {
      case $repo {
        'distrib': {
        }
        'scl': {
        }
        default : {
          fail("error - ${module_name} : unknown repository ${repo} for ${::operatingsystem}")
        }
      }
    }
  }
}


