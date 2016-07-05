define php::fpm::install (
  $ensure,
  $version,
) {
  case $::operatingsystem {
    'Ubuntu': {
      ::php::fpm::install::ubuntu { $name :
        ensure  => $ensure,
        version => $version,
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


