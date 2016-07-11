# == Class PHP
class php (
  $versions        = $::php::params::version,
  $repo            = $::php::params::repo,
  $log_path        = '/var/log',
) inherits php::params {

  # ------------------------
  # Validate
  # ------------------------
  case $::operatingsystem {
    'Debian': {
      if count(keys($versions)) > 1 and ($repo == 'distrib' or $repo == 'dotdeb') {
        fail("error - ${module_name} : ${::operatingsystem} doesn't support multiple php version")
      }
      if $repo == 'sury' {
        $versions_keys = keys($versions)
        if count(intersection($versions_keys, ['5.6' , '7.0', '7.1'])) != count($versions_keys) {
          fail("Error - ${module_name} versions ${versions_keys} are not supported by sury repository")
        }
      }
    }
    'Ubuntu': {
      if count(keys($versions)) > 1 and $repo == 'distrib'  {
        fail("error - ${module_name} : on ${::operatingsystem} you must set repo to ondrej to support multiple php version")
      }
      if $repo == 'ondrej' {
        $versions_keys = keys($versions)
        if count(intersection($versions_keys, ['5.6' , '7.0', '7.1'])) != count($versions_keys) {
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
  # Let's go
  # ------------------------
  class { '::php::globals': } ->
  class { '::php::repo': repo => $repo }
  create_resources('::php::install', $versions, { 'require' => Class['::php::repo'], })
}

