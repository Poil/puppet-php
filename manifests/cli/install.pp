define php::cli::install (
  $ensure = 'present',
  $custom_config = {},
) {
  case $::operatingsystem {
    'Ubuntu': {
      ::php::cli::install::ubuntu { $name :
        ensure         => $ensure,
        custom_config  => $custom_config,
      }
    }
    'Debian': {
      ::php::cli::install::debian { $name :
        ensure        => $ensure,
        custom_config => $custom_config,
      }
    }
    'RedHat', 'CentOS','OracleLinux': {
      #::php::cli::install::redhat { $name: ensure => $ensure}
    }
    default: {
    }
  }
}


