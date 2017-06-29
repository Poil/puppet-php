# == define php::fpm::service
define php::fpm::service (
  $ensure,
  $repo,
  $enable,
) {
  case $::operatingsystem {
    'Ubuntu': {
      ::php::fpm::service::ubuntu { $name :
        ensure => $ensure,
        enable => $enable
      }
    }
    'Debian': {
      ::php::fpm::service::debian { $name :
        ensure => $ensure,
        enable => $enable
      }
    }
    'RedHat', 'CentOS','OracleLinux': {
      ::php::fpm::service::redhat { $name :
        ensure => $ensure,
        enable => $enable
      }
    }
    default: {
      fail("Error - ${module_name}, unsupported OperatingSystem ${::operatingsystem}")
    }
  }
}
