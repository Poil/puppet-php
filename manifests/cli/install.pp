# == define php::cli::install
define php::cli::install (
  $ensure = 'present',
  $repo = $::php::repo,
  $custom_config = {},
) {
  $default_config = {
    'PHP' => { 'memory_limit' => '-1' }
  }
  $custom_cli_config = deep_merge($default_config, $custom_config)

  case $::operatingsystem {
    'Ubuntu': {
      ::php::cli::install::ubuntu { $name :
        ensure        => $ensure,
        custom_config => $custom_cli_config,
      }
    }
    'Debian': {
      ::php::cli::install::debian { $name :
        ensure        => $ensure,
        custom_config => $custom_cli_config,
      }
    }
    'RedHat', 'CentOS','OracleLinux': {
      ::php::cli::install::redhat { $name :
        ensure        => $ensure,
        custom_config => $custom_cli_config,
      }
    }
    default: {
    }
  }
}


