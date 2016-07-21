# == define php::fpm::install
define php::fpm::install (
  $ensure = 'present',
  $custom_config = {},
) {
  case $::operatingsystem {
    'Ubuntu': {
      ::php::fpm::install::ubuntu { $name :
        ensure         => $ensure,
        custom_config  => $custom_config,
      }
    }
    'Debian': {
      ::php::fpm::install::debian { $name :
        ensure         => $ensure,
        custom_config  => $custom_config,
      }
    }
    'RedHat', 'CentOS','OracleLinux': {
      ::php::fpm::install::redhat { $name :
        ensure         => $ensure,
        custom_config  => $custom_config,
      }
    }
    default: {
    }
  }
}


