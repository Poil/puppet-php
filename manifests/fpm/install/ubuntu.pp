define php::fpm::install::ubuntu (
  $ensure,
  $custom_config,
) {
  case $::php::repo {
    'distrib': {
      $package_name = 'php5-fpm'
      $config_dir = '/etc/php5'
      $binary_path = '/usr/bin/php5'
    }
    'ondrej': {
      $package_name = "php${name}-fpm"
      $config_dir = "/etc/php/${name}"
      $binary_path = "/usr/bin/php${name}"
    }
    default: {
      fail("error - ${module_name} unknown repository ${::php::repo}")
    }
  }

  package { $package_name:
    ensure => $ensure,
  }

  $default_fpm_conf = {
    'path' => "${config_dir}/fpm/php.ini"
  }

  $config = merge($::php::default_hardening_conf, $custom_config)

  create_resources(ini_setting, $custom_config, $default_fpm_conf)

}
