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
      #::php::fpm::install::debian { $name: ensure => $ensure}
    }
    'RedHat', 'CentOS','OracleLinux': {
      #::php::fpm::install::redhat { $name: ensure => $ensure}
    }
    default: {
    }
  }
}


