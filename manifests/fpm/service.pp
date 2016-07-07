define php::fpm::service (
  $ensure,
  $enable,
) {
  case $::operatingsystem {
    'Ubuntu': {
      ::php::fpm::service::ubuntu { $name :
        ensure  => $ensure,
        enable  => $enable
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



