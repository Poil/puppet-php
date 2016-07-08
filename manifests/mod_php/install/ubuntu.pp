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

  case $ensure {
    'present', 'installed', 'latest': {
      $default_mod_php_config = {
        'path'    => "${config_dir}/apache2/php.ini"
        'require' => "Package[${package_name}]"
      }

      $mod_php_config = deep_merge($::php::globals::default_hardening_config, $custom_config)
      create_ini_settings($mod_php_config, $default_mod_php_config)
    }
    'absent', 'purged': {
      file { "${config_dir}/fpm/php.ini":
        ensure => absent
      }
    }
    default: {
      fail("Error - ${module_name}, unknown ensure value '${ensure}'")
    }
  }
}
