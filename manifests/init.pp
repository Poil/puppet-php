# == Class PHP
class php (
  $versions            = $::php::params::version,
  $repo                = $::php::params::repo,
  $centos_mirror_url   = 'http://ftp.ciril.fr/pub/linux',
  $log_path            = '/var/log',
  $tmp_path            = '/tmp',
  $session_save_path   = undef,
  $apache_service_name = $::php::params::apache_service_name,
  $nginx_service_name  = $::php::params::nginx_service_name,
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
        fail("Error - ${module_name} : On ${::operatingsystem} you must set repo to ondrej to support multiple php version")
      }
      if $repo == 'ondrej' {
        $versions_keys = keys($versions)
        if count(intersection($versions_keys, ['5.6' , '7.0', '7.1'])) != count($versions_keys) {
          fail("Error - ${module_name} : Versions ${versions_keys} are not supported by ondrej repository")
        }
      }
    }
    'RedHat', 'CentOS', 'OracleLinux': {
      if count(keys($versions)) > 1 and $repo == 'distrib'  {
        fail("Error - ${module_name} : On ${::operatingsystem} you must set repo to scl to support multiple php version")
      }
      if $repo == 'scl' {
        case $::operatingsystemmajrelease {
          '6', '7': {
            $versions_keys = keys($versions)
            if count(intersection($versions_keys, ['5.4' , '5.5', '5.6'])) != count($versions_keys) {
              fail("Error - ${module_name} versions ${versions_keys} are not supported by scl repository")
            }
          }
          default : {
            fail("Error - ${module_name} : SCL repo is unsupported on ${::operatingsystem} ${::operatingsystemmajrelease}")
          }
        }
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

  class { '::php::folders': }

  create_resources('::php::install', $versions, { 'require' => Class['::php::repo'], })
}

