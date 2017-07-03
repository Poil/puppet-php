# == define php::fpm::logrotate::redhat
define php::fpm::logrotate::redhat (
  $ensure,
  $repo,
  $custom_config,
) {
  case $repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '5', '6', '7': {
          $logrotate_name = 'php-fpm'
          $logrotate_mainfile = '/var/log/php5-fpm.log'
        }
        default: {
          fail("Error - ${module_name}, unsupported OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'scl': {
      case $name {
        '5.4': {
          $logrotate_name = 'rh-php54-php-fpm'
          $logrotate_mainfile = '/var/opt/rh/rh-php54/log/php-fpm/*.log'
        }
        '5.5': {
          $logrotate_name = 'rh-php55-php-fpm'
          $logrotate_mainfile = '/var/opt/rh/rh-php55/log/php-fpm/*.log'
        }
        '5.6': {
          $logrotate_name = 'rh-php56-php-fpm'
          $logrotate_mainfile = '/var/opt/rh/rh-php56/log/php-fpm/*.log'
        }
        '7.0': {
          $logrotate_name = 'rh-php70-php-fpm'
          $logrotate_mainfile = '/var/opt/rh/rh-php70/log/php-fpm/*.log'
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
      # don't purge on redhat, fpm and mod_php is the same ini file
    }
    default: {
      fail("Error - ${module_name}, unknown ensure value '${ensure}'")
    }
  }
}

