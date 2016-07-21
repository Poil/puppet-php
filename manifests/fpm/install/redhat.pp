define php::fpm::install::redhat (
  $ensure,
  $custom_config,
) {
  case $::php::repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '5', '6', '7': {
          $package_name = 'php-fpm'
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
          $package_name = 'php54-php-fpm'
          $config_dir = '/opt/rh/php54/root/etc'
          $binary_path = '/opt/rh/php54/root/bin/php'
        }
        '5.5': {
          $package_name = 'php55-php-fpm'
          $config_dir = '/opt/rh/php55/root/etc'
          $binary_path = '/opt/rh/php55/root/bin/php'
        }
        '5.6': {
          $package_name = 'rh-php56-php-fpm'
          $config_dir = '/opt/rh/rh-php56/root/etc'
          $binary_path = '/opt/rh/rh-php56/root/bin/php'
        }
        default: {
          fail("Error - ${module_name}, unsupported version ${name} on OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
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
        'path'    => "${config_dir}/php.ini",
      }

      if $::php::session_save_path {
        $fpm_config = deep_merge($::php::globals::default_hardening_config, $custom_config, { 'PHP' => { 'session.save_path' => $::php::session_save_path} } )
      } else {
        $fpm_config = deep_merge($::php::globals::default_hardening_config, $custom_config)
      }

      $fpm_config = deep_merge($::php::globals::default_hardening_config, $custom_config)

      ::php::config { "fpm_${name}":
        custom_config  => $fpm_config,
        default_config => $default_fpm_config,
        require        => Package[$package_name],
      }
    }
    'absent', 'purged': {
      file { "${config_dir}/php.ini":
        ensure => absent
      }
    }
    default: {
      fail("Error - ${module_name}, unknown ensure value '${ensure}'")
    }
  }
}
