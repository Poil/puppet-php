# == define php::mod_php::install
define php::mod_php::install (
  $ensure = 'present',
  $custom_config = {},
) {
  case $::operatingsystem {
    'Ubuntu': {
      ::php::mod_php::install::ubuntu { $name :
        ensure        => $ensure,
        custom_config => $custom_config,
      }
    }
    'Debian': {
      ::php::mod_php::install::debian { $name :
        ensure        => $ensure,
        custom_config => $custom_config,
      }
    }
    'RedHat', 'CentOS','OracleLinux': {
      #::php::mod_php::install::redhat { $name: ensure => $ensure}
    }
    default: {
    }
  }
}
