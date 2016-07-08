define php::mod_php::install::ubuntu (
  $ensure,
  $custom_config,
) {
  case $::php::repo {
    'distrib': {
      $package_name = 'libapache2-mod-php'
      $config_dir = '/etc/php5'
      $binary_path = '/usr/bin/php5'
    }
    'ondrej': {
      $package_name = "libapache2-mod-php${name}"
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

  $default_mod_php_conf = {
    'path' => "${config_dir}/apache2/php.ini"
  }

  $config = deep_merge($::php::default_hardening_conf, $custom_config)

  create_ini_settings($custom_config, $default_mod_php_conf)

}
