# == define php::fpm::pool::debian
define php::fpm::pool::debian(
  $config,
  $version,
  $listen,
  $ensure = 'present',
  $pool_name = $name,
) {
  if !has_key($::php::fpm_socket_dir, $::operatingsystem) {
    fail("Error - ${module_name} : Can't find os '${::operatingsystem}' in ::php::fpm_socket_dir")
  } elsif !has_key($::php::fpm_socket_dir[$::operatingsystem], $::operatingsystemmajrelease) {
    fail("Error - ${module_name} : Can't find osmajrelease '${::operatingsystemmajrelease}' in ::php::fpm_socket_dir[${::operatingsystem}]")
  } elsif !has_key($::php::fpm_socket_dir[$::operatingsystem][$::operatingsystemmajrelease], $::php::repo) {
    fail("Error - ${module_name} : Can't find repo '${::php::repo}' in ::php::fpm_socket_dir[${::operatingsystem}][${::operatingsystemmajrelease}]")
  }

  # We always use the path from the repo, there is no way to determine if the package is from distrib or from repo if repo is declared
  $default_socket_dir = $::php::fpm_socket_dir[$::operatingsystem][$::operatingsystemmajrelease][$::php::repo]
  $_listen = pick($listen, "${default_socket_dir}/php${version}-fpm.${pool_name}.sock")

  case $::php::repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '7', '8': {
          $config_dir = '/etc/php5'
        }
        default: {
          fail("Error - ${module_name}, unsupported OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'sury': {
      $config_dir = "/etc/php/${version}"
    }
    default: {
      fail("Error - ${module_name}, unknown repository ${::php::repo}")
    }
  }

  $default_debian_pool_config = {
    'path'     => "${config_dir}/fpm/pool.d/${pool_name}.conf",
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
      file { "${config_dir}/fpm/pool.d/${pool_name}.conf":
        ensure => absent
      }
    }
    default: {
      fail("Error - ${module_name}, unknown ensure value '${ensure}'")
    }
  }
}
