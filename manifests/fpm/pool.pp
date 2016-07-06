# == define php::fpm::pool
define php::fpm::pool (
  $version,
  $ensure = 'present',
  $custom_pool_config = {},
  $user = $::php::user,
  $group = $::php::group,
  $listen = '',
  $listen_owner = $::php::user,
  $listen_group = $::php::group,
  $listen_mode = '0660',
  $pm = 'ondemand',
  $pm_max_children = 5,
  $pm_start_servers = 2,
  $pm_max_spare_servers = 3,
  $pm_process_idle_timeout = '10s',
  $pm_max_requests = 500,
  $log_path = $::php::log_path,
) {

  $default_pool_config = {
    'www'                             => {
      'user'                          => $user,
      'group'                         => $group,
      'listen.owner'                  => $listen_owner,
      'listen.group'                  => $listen_group,
      'listen.mode'                   => $listen_mode,
      'pm'                            => $pm,
      'pm.max_children'               => $pm_max_children,
      'pm.start_servers'              => $pm_start_servers,
      'pm.max_spare_servers'          => $pm_max_spare_servers,
      'pm.process_idle_timeout'       => $pm_process_idle_timeout,
      'pm.max_requests'               => $pm_max_requests,
      'php_flag[display_errors]'      => 'off',
      'php_admin_value[error_log]'    => "${log_path}/fpm-php.${name}.log",
      'php_admin_flag[log_errors]'    => 'on',
      'php_admin_value[memory_limit]' => '128M',
    }
  }

  $pool_config = merge($default_pool_config, $custom_pool_config)

  case $::operatingsystem {
    'Ubuntu': {
      php::fpm::pool::ubuntu { $name:
        config  => $pool_config,
        version => $version,
        listen  => $listen,
      }
    }
  }
}


