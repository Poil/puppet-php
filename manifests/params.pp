# == Class php::params
class php::params {
  $repo = 'distrib'
  $enable_mod_php = false
  $enable_phpfpm = false

  case $::operatingsystem {
    'Debian': {
      case $::operatingsystemmajrelease {
        '7': {
          $version = ['5.4']
        }
        '8': {
          $version = ['5.6']
        }
        default: {
          fail("Error - ${module_name} : ${::operatingsystem} ${::operatingsystemmajrelease} is not supported")
        }
      }
    }
    'Ubuntu': {
      case $::operatingsystemmajrelease {
        '14.04': {
          $version = ['5.5']
        }
        '16.04': {
          $version = ['7.0']
        }
        default: {
          fail("Error - ${module_name} : ${::operatingsystem} ${::operatingsystemmajrelease} is not supported")
        }
      }
    }
    'RedHat', 'CentOS', 'OracleLinux': {
      case $::operatingsystemmajrelease {
        '6': {
          $version = ['5.3']
        }
        '7': {
          $version = ['5.4']
        }
        default: {
          fail("Error - ${module_name} : ${::operatingsystem} ${::operatingsystemmajrelease} is not supported")
        }
      }
    }
  }
}

