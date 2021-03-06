# == define php::fpm::pool::debian
define php::fpm::pool::debian(
  $config,
  $repo,
  $version,
  $listen,
  $ensure = 'present',
) {
  if ($name =~ /^(.+)##(.+)$/) {
    $pool_name = $2
  } else {
    fail("Error - ${module_name}, Invalid pool name : ${name}")
  }

  case $repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '7', '8': {
          $config_dir = '/etc/php5'
        }
        default: {
          fail("Error - ${module_name}, unsupported OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'sury': {
      $config_dir = "/etc/php/${version}"
    }
    default: {
      fail("Error - ${module_name}, unknown repository ${repo}")
    }
  }

  $default_debian_pool_config = {
    'path'     => "${config_dir}/fpm/pool.d/${pool_name}.conf",
  }

  $default_config = {
    "${pool_name}"  => { # lint:ignore:only_variable_string
      'listen' => $listen,
    }
  }

  $pool_config = deep_merge($config, $default_config)

  case $ensure {
    'present', 'installed', 'latest': {
      create_ini_settings($pool_config, $default_debian_pool_config)
    }
    'absent', 'purged': {
      file { "${config_dir}/fpm/pool.d/${pool_name}.conf":
        ensure => absent
      }
    }
    default: {
      fail("Error - ${module_name}, unknown ensure value '${ensure}'")
    }
  }
}
