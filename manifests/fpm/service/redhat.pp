# == define php::fpm::service::redhat
define php::fpm::service::redhat (
  $ensure,
  $repo,
  $enable,
) {
  case $repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '5', '6', '7': {
          $service_name = 'php-fpm'
        }
        default: {
          fail("Error - ${module_name}, unsupported OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'scl': {
      case $name {
        '5.4': {
          $service_name = 'php54-php-fpm'
        }
        '5.5': {
          $service_name = 'php55-php-fpm'
        }
        '5.6': {
          $service_name = 'rh-php56-php-fpm'
        }
        '7.0': {
          $service_name = 'rh-php70-php-fpm'
        }
        default: {
          fail("Error - ${module_name}, unsupported version ${name} on OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
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
