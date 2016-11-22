# == define php::fpm::pool::ubuntu
define php::fpm::pool::ubuntu(
  $config,
  $version,
  $listen,
  $ensure = 'present',
  $pool_name = $name,
) {
  $os = $::osfamily ? {
    'Debian' => $::operatingsystem,
    'RedHat' => $::osfamily,
    default  => $::osfamily,
  }

  if !has_key($::php::fpm_socket_dir, $os) {
    fail("Error - ${module_name} : Can't find os '${os}' in ::php::fpm_socket_dir")
  } elsif !has_key($::php::fpm_socket_dir[$os], $version) {
    fail("Error - ${module_name} : Can't find version '${version}' in ::php::fpm_socket_dir[${os}]")
  } elsif !has_key($::php::fpm_socket_dir[$os][$version], $::php::repo) {
    fail("Error - ${module_name} : Can't find repo '${::php::repo}' in ::php::fpm_socket_dir[${os}][${version}]")
  }

  # We always use the path from the repo, there is no way to determine if the package is from distrib or from repo if repo is declared
  $default_socket_dir = $::php::fpm_socket_dir[$os][$version][$::php::repo]

  $_listen = pick($listen, "${default_socket_dir}/php${version}-fpm.${pool_name}.sock")

  case $::php::repo {
    'distrib': {
      case $::operatingsystemmajrelease {
        '12.04', '14.04': {
          $config_dir = '/etc/php5'
        }
        '16.04': {
          $config_dir = '/etc/php/7.0'
        }
        default: {
          fail("Error - ${module_name}, unsupported OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'ondrej': {
      $config_dir = "/etc/php/${version}"
    }
    default: {
      fail("Error - ${module_name}, unknown repository ${::php::repo}")
    }
  }

  $default_ubuntu_pool_config = {
    'path'     => "${config_dir}/fpm/pool.d/${pool_name}.conf",
  }

  $default_config = {
    "${pool_name}"  => {
      'listen' => $_listen,
    }
  }

  $pool_config = deep_merge($config, $default_config)

  case $ensure {
    'present', 'installed', 'latest': {
      create_ini_settings($pool_config, $default_ubuntu_pool_config)
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
