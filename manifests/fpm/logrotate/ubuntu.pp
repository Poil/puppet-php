# == define php::fpm::logrotate::ubuntu
define php::fpm::logrotate::ubuntu (
  $ensure,
  $repo,
  $custom_config,
) {
  case $repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '12.04', '14.04': {
          $logrotate_name = 'php5-fpm'
          $logrotate_mainfile = '/var/log/php5-fpm.log'
        }
        '16.04': {
          $logrotate_name = 'php7.0-fpm'
          $logrotate_mainfile = '/var/log/php7.0-fpm.log'
        }
        default: {
          fail("Error - ${module_name}, unsupported OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'ondrej': {
      $logrotate_name = "php${name}-fpm"
      $logrotate_mainfile = "/var/log/php${name}-fpm.log"
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
