# == Class php::params
class php::params {
  $repo = 'distrib'
  $fpm_socket_dir = {
    'Debian'      => {
      '7'         => {
        'distrib' => { 'default' => '/run', },
      },
      '8'         => {
        'distrib' => { 'default' => '/run', },
        'sury'    => { 'default' =>  '/run/php', },
      },
    },
    'Ubuntu'      => {
      '12.04'     => {
        'distrib' => { 'default' => '/var/run', },
        'ondrej'  => { 'default' => '/run/php', },
      },
      '14.04'     => {
        'distrib' => { 'default' => '/var/run', },
        'ondrej'  => { 'default' => '/run/php', },
      },
      '16.04'     => {
        'distrib' => { 'default' => '/run/php', },
        'ondrej'  => { 'default' => '/run/php', },
      },
    },
    'RedHat'      => {
      '5'         => {
        'distrib' => { 'default' => '/var/run/php-fpm', },
      },
      '6'         => {
        'distrib' => { 'default' =>  '/var/run/php-fpm', },
        'scl'     => {
          'default'  => '/run/php-fpm',
          '5.6'      => '/var/opt/rh/rh-php56/run/php-fpm',
        },
      },
      '7'         => {
        'distrib' => { 'default' => '/run/php-fpm', },
        'scl'     => {
          'default' => '/run/php-fpm',
          '5.6'     => '/var/opt/rh/rh-php56/run/php-fpm',
          '7.0'     => '/var/opt/rh/rh-php70/run/php-fpm',
          '7.1'     => '/var/opt/rh/rh-php71/run/php-fpm',
        },
      },
    },
  }

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
    default: {
      fail("Error - ${module_name} : ${::operatingsystem} ${::operatingsystem} is not supported")
    }
  }
}

