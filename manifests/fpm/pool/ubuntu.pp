# == define php::fpm::pool::ubuntu
define php::fpm::pool::ubuntu(
  $config,
  $version,
  $listen,
) {
  $_listen = pick($listen, "/run/php/php${version}-fpm.${name}.sock")

  case $::php::repo {
    'distrib': {
      $config_dir = '/etc/php5'
    }
    'ondrej': {
      $config_dir = "/etc/php/${version}"
    }
    default: {
      fail("error - ${module_name} unknown repository ${::php::repo}")
    }
  }

  $default_ubuntu_pool_config = {
    'path'     => "${config_dir}/fpm/pool.d/${name}.conf",
  }

  $default_config = {
    "${name}"  => {
      'listen' => $_listen,
    }
  }

  $pool_config = merge($config, $default_config)

  create_ini_settings($pool_config, $default_ubuntu_pool_config)
}
