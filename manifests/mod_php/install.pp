define php::mod_php::install (
  $ensure,
  $custom_config,
) {
  case $::operatingsystem {
    'Ubuntu': {
      ::php::mod_php::install::ubuntu { $name :
        ensure         => $ensure,
        custom_config  => $custom_config,
      }
    }
    'Debian': {
      #::php::mod_php::install::debian { $name: ensure => $ensure}
    }
    'RedHat', 'CentOS','OracleLinux': {
      #::php::mod_php::install::redhat { $name: ensure => $ensure}
    }
    default: {
    }
  }
}


