# == define php::fpm::pool::redhat
define php::fpm::pool::redhat(
  $config,
  $version,
  $listen,
  $ensure = 'present',
  $pool_name = $name,
) {
  $_listen = pick($listen, "/run/php/php${version}-fpm.${pool_name}.sock")

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
          $config_dir = '/opt/rh/rh-php56/root/etc'
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
