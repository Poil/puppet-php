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
          $fpm_socket_dir = '/run'
        }
        '8': {
          $versions = ['5.6']
          $fpm_socket_dir = '/run/php'
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
          $fpm_socket_dir = '/var/run'
        }
        '14.04': {
          $versions = ['5.5']
          $fpm_socket_dir = '/var/run'
        }
        '16.04': {
          $versions = ['7.0']
          $fpm_socket_dir = '/run/php'
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
          $fpm_socket_dir = '/var/run/php-fpm'
        }
        '7': {
          $versions = ['5.4']
          $fpm_socket_dir = '/var/run/php-fpm'
        }
        default: {
          fail("Error - ${module_name} : ${::operatingsystem} ${::operatingsystemmajrelease} is not supported")
        }
      }
    }
  }
}

