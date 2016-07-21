# == define php::extension
define php::extension (
  $ensure,
  $php_version,
  $sapi = ['ALL'],
  $extension_config = {},
  $package_prefix = undef,
) {

  case $::operatingsystem {
    'Ubuntu': {
      ::php::extension::ubuntu { $name:
        ensure           => $ensure,
        php_version      => $php_version,
        sapi             => $sapi,
        extension_config => $extension_config,
        package_prefix   => $package_prefix,
      }
    }
    'Debian': {
      ::php::extension::debian { $name:
        ensure           => $ensure,
        php_version      => $php_version,
        sapi             => $sapi,
        extension_config => $extension_config,
        package_prefix   => $package_prefix,
      }
    }
    'RedHat', 'CentOS', 'OracleLinux': {
    }
    default: {
      fail("Error - ${module_name}, unsupported OS ${::operatingsytem}")
    }
  }
}
