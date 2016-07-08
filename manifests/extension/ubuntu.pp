define php::extension::ubuntu (
  $ensure,
  $php_version,
) {
  case $::php::repo {
    'distrib': {
      $config_dir = '/etc/php5'
      $binary_path = '/usr/bin/php5'
      case $::operatingsystemmajrelease {
        '16.04': {
          $package_prefix = 'php7-'
        }
        '14.04': {
          $package_prefix = 'php5-'
        }
        default: {
          fail("Error - ${module_name}, Unknown OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'ondrej': {
      $config_dir = "/etc/php/${name}"
      $binary_path = "/usr/bin/php${name}"
      $package_prefix = "php${php_version}-"
    }
    default: {
      fail("Error - ${module_name}, Unknown repository ${::php::repo}")
    }
  }
  $extension_name = "${package_prefix}${name}"

  package { $extension_name:
    ensure => $ensure,
  }

  #case $ensure {
  #  'present', 'installed', 'latest': {
  #    $default_fpm_config = {
  #      'path' => "${config_dir}/fpm/php.ini"
  #    }

  #    $fpm_config = deep_merge($::php::globals::default_hardening_config, $custom_config)
  #    create_ini_settings($fpm_config, $default_fpm_config)
  #  }
  #  'absent', 'purged': {
  #    file { "${config_dir}/fpm/php.ini":
  #      ensure => absent
  #    }
  #  }
  #  default: {
  #    fail("Error - ${module_name}, unknown ensure value '${ensure}'")
  #  }
  #}
}
