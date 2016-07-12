define php::fpm::service::ubuntu (
  $ensure,
  $enable,
) {
  case $::php::repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '12.04', '14.04': {
          $service_name = 'php5-fpm'
        }
        '16.04': {
          $service_name = 'php7.0-fpm'
        }
        default: {
          fail("Error - ${module_name}, unsupported OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'ondrej': {
      $service_name = "php${name}-fpm"
    }
    default: {
      fail("error - ${module_name} unknown repository ${::php::repo}")
    }
  }

  service { $service_name:
    ensure => $ensure,
    enable => $enable,
  }
}
