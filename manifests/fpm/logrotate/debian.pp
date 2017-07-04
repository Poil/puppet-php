# == define php::fpm::logrotate::debian
define php::fpm::logrotate::debian (
  $ensure,
  $repo,
  $custom_config,
) {
  case $repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '7', '8': {
          $logrotate_name = 'php5-fpm'
          $logrotate_mainfile = '/var/log/php5-fpm'
        }
        default: {
          fail("Error - ${module_name}, unsupported OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'sury': {
      $logrotate_name = "php${name}-fpm"
      $logrotate_mainfile = "/var/log/php${name}-fpm"
    }
    default: {
      fail("error - ${module_name} unknown repository ${repo}")
    }
  }

  case $ensure {
    'present', 'installed', 'latest': {
      file { "/etc/logrotate.d/${logrotate_name}":
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("${module_name}/logrotate/${::osfamily}/php-fpm-pool.erb"),
      }
    }
    'absent', 'purged': {
      file { "/etc/logrotate.d/${logrotate_name}":
        ensure => absent
      }
    }
    default: {
      fail("Error - ${module_name}, unknown ensure value '${ensure}'")
    }
  }
}
