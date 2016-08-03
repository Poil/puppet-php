# === define php::mod_php::install::debian
define php::mod_php::install::debian (
  $ensure,
  $custom_config,
) {
  case $::php::repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '7', '8': {
          $package_name = 'libapache2-mod-php5'
          $config_dir = '/etc/php5'
          $binary_path = '/usr/bin/php5'
        }
        default: {
          fail("Error - ${module_name}, unsupported OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'sury': {
      $package_name = "libapache2-mod-php${name}"
      $config_dir = "/etc/php/${name}"
      $binary_path = "/usr/bin/php${name}"
    }
    default: {
      fail("error - ${module_name} unknown repository ${::php::repo}")
    }
  }


  case $ensure {
    'present', 'installed', 'latest': {
      package { $package_name:
        ensure => $ensure,
        notify => Service['apache2'],
      }

      $default_mod_php_config = {
        'path'    => "${config_dir}/apache2/php.ini",
      }

      if $::php::session_save_path {
        $mod_php_config = deep_merge($::php::globals::default_hardening_config, $custom_config, { 'PHP' => { 'session.save_path' => $::php::session_save_path} } )
      } else {
        $mod_php_config = deep_merge($::php::globals::default_hardening_config, $custom_config)
      }

      ::php::config { "mod_php_${name}":
        custom_config  => $mod_php_config,
        default_config => $default_mod_php_config,
        require        => Package[$package_name],
        notify         => Service[$::php::apache_service_name],
      }
    }
    'absent', 'purged': {
      package { $package_name:
        ensure => $ensure,
      }

      file { "${config_dir}/mod_php/php.ini":
        ensure => absent
      }
    }
    default: {
      fail("Error - ${module_name}, unknown ensure value '${ensure}'")
    }
  }
}
