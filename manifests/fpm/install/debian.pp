# == define php::fpm::install::debian
define php::fpm::install::debian (
  $ensure,
  $repo,
  $custom_config,
) {
  case $repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '7', '8': {
          $package_name = 'php5-fpm'
          $config_dir = '/etc/php5'
          $binary_path = '/usr/bin/php5'
          $logrotate_name = 'php5-fpm'
          $logrotate_mainfile = '/var/log/php5-fpm'
        }
        default: {
          fail("Error - ${module_name}, unsupported OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'sury': {
      $package_name = "php${name}-fpm"
      $config_dir = "/etc/php/${name}"
      $binary_path = "/usr/bin/php${name}"
      $logrotate_name = "php${name}-fpm"
      $logrotate_mainfile = "/var/log/php${name}-fpm"
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
      $default_fpm_config = {
        'path'    => "${config_dir}/fpm/php.ini",
      }

      if $::php::session_save_path {
        $fpm_config = deep_merge($::php::globals::default_hardening_config, $custom_config, { 'PHP' => { 'session.save_path' => $::php::session_save_path} } )
      } else {
        $fpm_config = deep_merge($::php::globals::default_hardening_config, $custom_config)
      }

      ::php::config { "fpm_${name}":
        custom_config  => $fpm_config,
        default_config => $default_fpm_config,
        require        => Package[$package_name],
      }

      file { "/etc/logrotate.d/${logrotate_name}":
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("${module_name}/logrotate/${::osfamily}/php-fpm-pool.erb"),
      }
    }
    'absent', 'purged': {
      file { "${config_dir}/fpm/php.ini":
        ensure => absent
      }
      file { '/etc/logrotate.d/php-fpm-pool':
        ensure => absent
      }
    }
    default: {
      fail("Error - ${module_name}, unknown ensure value '${ensure}'")
    }
  }
}
