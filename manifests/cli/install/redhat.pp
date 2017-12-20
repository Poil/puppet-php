# == define php::cli::install::redhat
define php::cli::install::redhat (
  $ensure,
  $repo,
  $custom_config,
) {
  case $repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '5', '6', '7': {
          $package_name = 'php-cli'
          $config_dir = '/etc'
          $binary_path = '/bin/php'
        }
        default: {
          fail("Error - ${module_name}, unsupported OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'scl': {
      case $name {
        '5.4': {
          $package_name = 'php54-php-cli'
          $config_dir = '/opt/rh/php54/root/etc'
          $binary_path = '/opt/rh/php54/root/bin/php'
        }
        '5.5': {
          $package_name = 'php55-php-cli'
          $config_dir = '/opt/rh/php55/root/etc'
          $binary_path = '/opt/rh/php55/root/bin/php'
        }
        '5.6': {
          $package_name = 'rh-php56-php-cli'
          $config_dir = '/etc/opt/rh/rh-php56'
          $binary_path = '/opt/rh/rh-php56/root/bin/php'
        }
        '7.0': {
          $package_name = 'rh-php70-php-cli'
          $config_dir = '/etc/opt/rh/rh-php70'
          $binary_path = '/opt/rh/rh-php70/root/bin/php'
        }
        '7.1': {
          $package_name = 'rh-php71-php-cli'
          $config_dir = '/etc/opt/rh/rh-php71'
          $binary_path = '/opt/rh/rh-php71/root/bin/php'
        }
        default: {
          fail("Error - ${module_name}, unsupported version ${name} on OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
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
        'path'    => "${config_dir}/php-cli.ini",
      }

      $cli_config = deep_merge($::php::globals::default_hardening_config, $custom_config)

      ::php::config { "cli_${name}":
        custom_config  => $cli_config,
        default_config => $default_cli_config,
        require        => Package[$package_name],
      }
    }
    'absent', 'purged': {
      file { "${config_dir}/php-cli.ini":
        ensure => absent,
      }
    }
    default: {
      fail("Error - ${module_name}, unknown ensure value '${ensure}'")
    }
  }
}
