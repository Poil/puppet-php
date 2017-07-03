# == define php::fpm::logrotate
define php::fpm::logrotate (
  $ensure = 'present',
  $repo = $::php::repo,
  $custom_config = {},
) {
  case $::operatingsystem {
    'Ubuntu': {
      ::php::fpm::logrotate::ubuntu { $name :
        ensure        => $ensure,
        repo          => $repo,
        custom_config => $custom_config,
      }
    }
    'Debian': {
      ::php::fpm::logrotate::debian { $name :
        ensure        => $ensure,
        repo          => $repo,
        custom_config => $custom_config,
      }
    }
    'RedHat', 'CentOS','OracleLinux': {
      ::php::fpm::logrotate::redhat { $name :
        ensure        => $ensure,
        repo          => $repo,
        custom_config => $custom_config,
      }
    }
    default: {
    }
  }
}
