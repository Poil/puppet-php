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
        if intersection($versions_keys, ['5.6' , '5.7', '7.0', '7.1']) == $versions_keys {
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
        if intersection($versions_keys, ['5.6' , '5.7', '7.0', '7.1']) == $versions_keys {
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
  # Default Config (globals)
  # ------------------------
  $default_config_hardening = {
    'PHP'                      => {
      'short_open_tag'         => 'Off',
      'asp_tags'               => 'Off',
      'safe_mode'              => 'Off', # On ?
      'safe_mode_gid'          => 'Off', # On ?
      'expose_php'             => 'Off',
      'max_execution_time'     => '30',
      'max_input_time'         => '60',
      'memory_limit'           => '128M',
      'display_errors'         => 'Off',
      'error_reporting'        => 'E_ALL & ~E_DEPRECATED',
      'display_startup_errors' => 'Off',
      'log_errors'             => 'On',
      'log_errors_max_len'     => '1024',
      'ignore_repeated_errors' => 'Off',
      'ignore_repeated_source' => 'Off',
      'report_memleaks'        => 'On',
      'track_errors'           => 'Off',
      'html_errors'            => 'Off',
      'register_globals'       => 'Off',
      'register_long_arrays'   => 'Off',
      'register_argc_argv'     => 'Off',
      'auto_globals_jit'       => 'On',
      'post_max_size'          => '8M',
      'upload_max_filesize'    => '10M',
      'max_file_uploads'       => '20',
      'allow_url_fopen'        => 'Off',
      'allow_url_include'      => 'Off',
      'default_socket_timeout' => '60',
      'date.timezone'          => 'Europe/Paris'
    }
  }
  case $::operatingsystem {
    'Debian': {
      $fpm_user = 'www-data'
      $fpm_group = 'www-data'
    }
    'Ubuntu': {
      $fpm_user = 'www-data'
      $fpm_group = 'www-data'
    }
    'RedHat', 'CentOS', 'OracleLinux': {
      $fpm_user = 'apache'
      $fpm_group = 'apache'
    }
    default: {
      fail("error - ${module_name} : ${::operatingsystem} isn't supported")
    }
  }

  # ------------------------
  # Let's go
  # ------------------------
  class { '::php::repo':
    repo => $repo
  }
  create_resources('::php::install', $versions, { 'require' => Class['::php::repo'], })
}

