# == Class php::params
class php::params {
  $repo = 'distrib'

  case $::operatingsystem {
    'Debian': {
      $apache_service_name = 'apache2'
      $nginx_service_name = 'nginx'
      case $::operatingsystemmajrelease {
        '7': {
          $versions = ['5.4']
        }
        '8': {
          $versions = ['5.6']
        }
        default: {
          fail("Error - ${module_name} : ${::operatingsystem} ${::operatingsystemmajrelease} is not supported")
        }
      }
    }
    'Ubuntu': {
      $apache_service_name = 'apache2'
      $nginx_service_name = 'nginx'
      case $::operatingsystemmajrelease {
        '12.04': {
          $versions = ['5.3']
        }
        '14.04': {
          $versions = ['5.5']
        }
        '16.04': {
          $versions = ['7.0']
        }
        default: {
          fail("Error - ${module_name} : ${::operatingsystem} ${::operatingsystemmajrelease} is not supported")
        }
      }
    }
    'RedHat', 'CentOS', 'OracleLinux': {
      $apache_service_name = 'httpd'
      $nginx_service_name = 'nginx'
      case $::operatingsystemmajrelease {
        '6': {
          $versions = ['5.3']
        }
        '7': {
          $versions = ['5.4']
        }
        default: {
          fail("Error - ${module_name} : ${::operatingsystem} ${::operatingsystemmajrelease} is not supported")
        }
      }
    }
  }
}

