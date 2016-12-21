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
          class { '::php::repo::debian':
            ensure => 'distrib'
          }
        }
        'dotdeb': {
          class { '::php::repo::debian':
            ensure => 'dotdeb'
          }
        }
        'sury': {
          class { '::php::repo::debian':
            ensure => 'sury'
          }
        }
        default : {
          fail("error - ${module_name} : unknown repository ${repo} for ${::operatingsystem}")
        }
      }
    }
    'CentOS', 'OracleLinux', 'RedHat': {
      case $repo {
        'distrib': {
        }
        'scl': {
          class { '::php::repo::redhat': ensure => present }
        }
        default : {
          fail("error - ${module_name} : unknown repository ${repo} for ${::operatingsystem}")
        }
      }
    }
  }
}


