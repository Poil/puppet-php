# == define php::fpm::pool
define php::fpm::pool (
  $version,
  $pool_name = $name,
  $ensure = 'present',
  $custom_pool_config = {},
  $user = $::php::globals::fpm_user,
  $group = $::php::globals::fpm_group,
  $listen = '',
  $listen_owner = $::php::globals::fpm_user,
  $listen_group = $::php::globals::fpm_group,
  $listen_mode = '0660',
  $pm = 'ondemand',
  $pm_max_children = 5,
  $pm_start_servers = '',
  $pm_min_spare_servers = 1,
  $pm_max_spare_servers = 3,
  $pm_process_idle_timeout = '10s',
  $pm_max_requests = 500,
  $log_path = $::php::log_path,
) {

  $os = $::osfamily ? {
    'Debian' => $::operatingsystem,
    default  => $::osfamily,
  }

  if !has_key($::php::fpm_socket_dir, $os) {
    fail("Error - ${module_name} : Can't find os '${os}' in ::php::fpm_socket_dir")
  } elsif !has_key($::php::fpm_socket_dir[$os], $::operatingsystemmajrelease) {
    fail("Error - ${module_name} : Can't find osmajrelease '${::operatingsystemmajrelease}' in ::php::fpm_socket_dir[${os}]")
  } elsif !has_key($::php::fpm_socket_dir[$os][$::operatingsystemmajrelease], $::php::repo) {
    fail("Error - ${module_name} : Can't find repo '${::php::repo}' in ::php::fpm_socket_dir[${os}][${::operatingsystemmajrelease}]")
  }

  # We always use the path from the repo, there is no way to determine if the package is from distrib or from repo if repo is declared
  if has_key($::php::fpm_socket_dir[$os][$::operatingsystemmajrelease][$::php::repo], $version) {
    $default_socket_dir = $::php::fpm_socket_dir[$os][$::operatingsystemmajrelease][$::php::repo][$version]
    $_listen = pick($listen, "${default_socket_dir}/php${version}-fpm.${pool_name}.sock")
  } else {
    $default_socket_dir = $::php::fpm_socket_dir[$os][$::operatingsystemmajrelease][$::php::repo]['default']
    $_listen = pick($listen, "${default_socket_dir}/php${version}-fpm.${pool_name}.sock")
  }

  # -----------------------------
  # Validate
  case $pm{
    'dynamic': {
      if !empty($pm_start_servers) and ($pm_start_servers < $pm_min_spare_servers or $pm_start_servers > $pm_max_spare_servers) {
        fail("Error - ${module_name}, start_servers value must be : min_spare_servers > start_servers < max_spare_servers")
      }
    }
    'ondemand': { }
    'static': {
      if empty($pm_start_servers) {
        fail("Error - ${module_name}, start_servers must be set when pm = static")
      }
    }
    default: {
      fail("Error - ${module_name}, mode must be dynamic, ondemand or static")
    }
  }

  # -----------------------------
  # Config
  $default_pool_config = {
    "${pool_name}"                    => {
      'user'                          => $user,
      'group'                         => $group,
      'listen.owner'                  => $listen_owner,
      'listen.group'                  => $listen_group,
      'listen.mode'                   => $listen_mode,
      'pm'                            => $pm,
      'pm.max_children'               => $pm_max_children,
      'pm.start_servers'              => $pm_start_servers,
      'pm.min_spare_servers'          => $pm_min_spare_servers,
      'pm.max_spare_servers'          => $pm_max_spare_servers,
      'pm.process_idle_timeout'       => $pm_process_idle_timeout,
      'pm.max_requests'               => $pm_max_requests,
      'pm.status_path'                => "/pl-${version}-${pool_name}-status",
      'php_flag[display_errors]'      => 'off',
      'php_admin_value[error_log]'    => "${log_path}/php${version}-fpm.${pool_name}/error.log",
      'php_admin_flag[log_errors]'    => 'on',
      'php_admin_value[memory_limit]' => '128M',
    }
  }

  case $ensure {
    'absent': {
      file {"${log_path}/php${version}-fpm.${pool_name}":
        ensure => absent,
      }
    }
    'purged': {
      file {"${log_path}/php${version}-fpm.${pool_name}":
        ensure => absent,
        force  => true,
      }
    }
    default : {
      file {"${log_path}/php${version}-fpm.${pool_name}":
        ensure => directory,
        owner  => $user,
        group  => $group,
        mode   => '0755'
      }
    }
  }

  $pool_config = deep_merge($default_pool_config, $custom_pool_config)

  # -----------------------------
  # Call
  case $::operatingsystem {
    'Ubuntu': {
      ::php::fpm::pool::ubuntu { $name:
        ensure    => $ensure,
        pool_name => $pool_name,
        config    => $pool_config,
        version   => $version,
        listen    => $_listen,
      }
    }
    'Debian': {
      ::php::fpm::pool::debian { $name:
        ensure    => $ensure,
        pool_name => $pool_name,
        config    => $pool_config,
        version   => $version,
        listen    => $_listen,
      }
    }
    'RedHat', 'CentOS', 'OracleLinux': {
      ::php::fpm::pool::redhat { $name:
        ensure    => $ensure,
        pool_name => $pool_name,
        config    => $pool_config,
        version   => $version,
        listen    => $_listen,
      }
    }
    default : {
      fail("Error - ${module_name}, unsupported OperatingSystem ${::operatingsystem}")
    }
  }
}


