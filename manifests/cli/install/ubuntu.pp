define php::cli::install::ubuntu (
  $ensure,
  $custom_config,
) {
  case $::php::repo {
    'distrib': {
      $package_name = 'php5-cli'
      $config_dir = '/etc/php5'
      $binary_path = '/usr/bin/php5'
    }
    'ondrej': {
      $package_name = "php${name}-cli"
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
      $default_cli_config = {
        'path'    => "${config_dir}/cli/php.ini",
        'require' => "Package[${package_name}]"
      }

      $cli_config = deep_merge($::php::globals::default_hardening_config, $custom_config)
      create_ini_settings($cli_config, $default_cli_config)
    }
    'absent', 'purged': {
      file { "${config_dir}/cli/php.ini":
        ensure => absent
      }
    }
    default: {
      fail("Error - ${module_name}, unknown ensure value '${ensure}'")
    }
  }
}
