# == Class PHP
class php (
  $versions        = $::php::params::version,
  $repo            = $::php::params::repo,
) inherits php::params {

  # ------------------------
  # Validate
  # ------------------------
  case $::operatingsystem {
    'Debian': {
      if count(keys($versions)) > 1 {
        fail("error - ${module_name} : ${::operatingsystem} doesn't support multiple php version")
      }
    }
    'Ubuntu': {
      if count(keys($versions)) > 1 and $repo == 'distrib'  {
        fail("error - ${module_name} : on ${::operatingsystem} you must set repo to ondrej to support multiple php version")
      }
      if $repo == 'ondrej' {
        $versions_keys = keys($versions)
        if !($versions_keys in ['5.6' , '5.7', '7.0', '7.1']) {
          fail("Error - ${module_name} versions ${versions_keys} are not supported by ondrej repository")
        }
      }
    }
    'RedHat', 'CentOS', 'OracleLinux': {
      if count(keys($versions)) > 1 and $repo == 'distrib'  {
        fail("error - ${module_name} : on ${::operatingsystem} you must set repo to scl to support multiple php version")
      }
    }
    default: {
      fail("error - ${module_name} doesn't support operatingsystem ${::operatingsystem}")
    }
  }

  # ------------------------
  # Default Hash
  # ------------------------
  $default_fpm_conf = {
    'path' => '/etc/php/7.0/fpm/php.ini'
  }

  # ------------------------
  # Let's go
  # ------------------------
  class { '::php::repo':
    repo => $repo
  }

  ::php::mod_php { $versions :
    require  => Class['::php::repo'],
  }

  ::php::cli { $versions :
    require => Class['::php::repo'],
  }

  ::php::fpm { $versions :
    require => Class['::php::repo'],
  }
}

