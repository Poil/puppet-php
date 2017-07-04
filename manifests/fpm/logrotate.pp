# == define php::fpm::logrotate
define php::fpm::logrotate (
  $ensure = 'present',
  $repo = $::php::repo,
  $fpm_pools = {},
) {
  case $::operatingsystem {
    'Ubuntu': {
      ::php::fpm::logrotate::ubuntu { $name :
        ensure    => $ensure,
        repo      => $repo,
        fpm_pools => $fpm_pools,
      }
    }
    'Debian': {
      ::php::fpm::logrotate::debian { $name :
        ensure    => $ensure,
        repo      => $repo,
        fpm_pools => $fpm_pools,
      }
    }
    'RedHat', 'CentOS','OracleLinux': {
      ::php::fpm::logrotate::redhat { $name :
        ensure    => $ensure,
        repo      => $repo,
        fpm_pools => $fpm_pools,
      }
    }
    default: {
    }
  }
}
