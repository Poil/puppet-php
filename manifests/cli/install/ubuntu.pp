# == define php::cli::install::ubuntu
define php::cli::install::ubuntu (
  $ensure,
  $repo,
  $custom_config,
) {
  case $repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '12.04', '14.04': {
          $package_name = 'php5-cli'
          $config_dir = '/etc/php5'
          $binary_path = '/usr/bin/php5'
        }
        '16.04': {
          $package_name = 'php7.0-cli'
          $config_dir = '/etc/php/7.0'
          $binary_path = '/usr/bin/php7'
        }
        default: {
          fail("Error - ${module_name}, unsupported OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'ondrej': {
      $package_name = "php${name}-cli"
      $config_dir = "/etc/php/${name}"
      $binary_path = "/usr/bin/php${name}"
    }
    default: {
      fail("error - ${module_name} unknown repository ${repo}")
    }
  }

  package { $package_name:
    ensure => $ensure,
  }

  case $ensure {
    'present', 'installed', 'latest': {
      $default_cli_config = {
        'path'    => "${config_dir}/cli/php.ini",
      }

      $cli_config = deep_merge($::php::globals::default_hardening_config, $custom_config)

      ::php::config { "cli_${name}":
        custom_config  => $cli_config,
        default_config => $default_cli_config,
        require        => Package[$package_name],
      }
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
