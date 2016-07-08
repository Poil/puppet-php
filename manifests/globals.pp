class php::globals {
  # ------------------------
  # Default Config (globals)
  # ------------------------
  $default_hardening_config = {
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
      'error_reporting'        => 'E_ALL & ~E_DEPRECATED & ~E_STRICT',
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
      'date.timezone'          => 'Europe/Paris',
      'disable_functions'      => 'pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,',
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
}
