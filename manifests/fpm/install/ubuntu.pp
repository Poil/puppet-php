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

  case $ensure {
    'present', 'installed', 'latest': {
      $default_fpm_config = {
        'path'    => "${config_dir}/fpm/php.ini",
      }

      $fpm_config = deep_merge($::php::globals::default_hardening_config, $custom_config)

      ::php::config { "fpm_${name}":
        custom_config  => $fpm_config,
        custom_default => $default_fpm_config,
        require        => Package[$package_name],
      }
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
