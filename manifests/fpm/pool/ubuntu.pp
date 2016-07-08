# == define php::fpm::pool::ubuntu
define php::fpm::pool::ubuntu(
  $config,
  $version,
  $listen,
  $ensure = 'present',
  $pool_name = $name,
) {
  $_listen = pick($listen, "/run/php/php${version}-fpm.${pool_name}.sock")

  case $::php::repo {
    'distrib': {
      $config_dir = '/etc/php5'
    }
    'ondrej': {
      $config_dir = "/etc/php/${version}"
    }
    default: {
      fail("Error - ${module_name}, unknown repository ${::php::repo}")
    }
  }

  $default_ubuntu_pool_config = {
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
      create_ini_settings($pool_config, $default_ubuntu_pool_config)
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
