# == define php::fpm::service::debian
define php::fpm::service::debian (
  $ensure,
  $repo,
  $enable,
) {
  case $repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '7', '8': {
          $service_name = 'php5-fpm'
        }
        default: {
          fail("Error - ${module_name}, unsupported OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'sury': {
      $service_name = "php${name}-fpm"
    }
    default: {
      fail("error - ${module_name} unknown repository ${repo}")
    }
  }

  service { $service_name:
    ensure => $ensure,
    enable => $enable,
  }
}
