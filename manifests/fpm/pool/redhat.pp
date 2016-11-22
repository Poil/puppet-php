# == define php::fpm::pool::redhat
define php::fpm::pool::redhat(
  $config,
  $version,
  $listen,
  $ensure = 'present',
  $pool_name = $name,
) {
  if !has_key($::php::fpm_socket_dir, $::osfamily) {
    fail("Error - ${module_name} : Can't find os '${::osfamily}' in ::php::fpm_socket_dir")
  } elsif !has_key($::php::fpm_socket_dir[$::osfamily], $::operatingsystemmajrelease) {
    fail("Error - ${module_name} : Can't find osmajrelease '${::operatingsystemmajrelease}' in ::php::fpm_socket_dir[${::osfamily}]")
  } elsif !has_key($::php::fpm_socket_dir[$::osfamily][$::operatingsystemmajrelease], $::php::repo) {
    fail("Error - ${module_name} : Can't find repo '${::php::repo}' in ::php::fpm_socket_dir[${::osfamily}][${::operatingsystemmajrelease}]")
  }

  # We always use the path from the repo, there is no way to determine if the package is from distrib or from repo if repo is declared
  $default_socket_dir = $::php::fpm_socket_dir[$::osfamily][$::operatingsystemmajrelease][$::php::repo]
  $_listen = pick($listen, "${default_socket_dir}/php${version}-fpm.${pool_name}.sock")

  case $::php::repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '5', '6', '7': {
          $config_dir = '/etc'
        }
        default: {
          fail("Error - ${module_name}, unsupported OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'scl': {
      case $version {
        '5.4': {
          $config_dir = '/opt/rh/php54/root/etc'
        }
        '5.5': {
          $config_dir = '/opt/rh/php55/root/etc'
        }
        '5.6': {
          $config_dir = '/etc/opt/rh/rh-php56'
        }
        default: {
          fail("Error - ${module_name}, unsupported version ${version} on OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    default: {
      fail("error - ${module_name} unknown repository ${::php::repo}")
    }
  }

  $default_debian_pool_config = {
    'path'     => "${config_dir}/php-fpm.d/${pool_name}.conf",
  }

  $default_config = {
    "${pool_name}"  => {
      'listen' => $_listen,
    }
  }

  $pool_config = deep_merge($config, $default_config)

  case $ensure {
    'present', 'installed', 'latest': {
      create_ini_settings($pool_config, $default_debian_pool_config)
    }
    'absent', 'purged': {
      file { "${config_dir}/php-fpm.d/${pool_name}.conf":
        ensure => absent
      }
    }
    default: {
      fail("Error - ${module_name}, unknown ensure value '${ensure}'")
    }
  }
}
