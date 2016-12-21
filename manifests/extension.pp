# == define php::extension
define php::extension (
  $ensure,
  $php_version,
  $sapi = ['ALL'],
  $extension_config = {},
  $package_prefix = undef,
  $meta_package = [],
) {

  case $::operatingsystem {
    'Ubuntu': {
      ::php::extension::ubuntu { $name:
        ensure           => $ensure,
        type             => 'package',
        php_version      => $php_version,
        sapi             => $sapi,
        extension_config => $extension_config,
        package_prefix   => $package_prefix,
        meta_package     => $meta_package,
      }
    }
    'Debian': {
      ::php::extension::debian { $name:
        ensure           => $ensure,
        type             => 'package',
        php_version      => $php_version,
        sapi             => $sapi,
        extension_config => $extension_config,
        package_prefix   => $package_prefix,
        meta_package     => $meta_package,
      }
    }
    'RedHat', 'CentOS', 'OracleLinux': {
      ::php::extension::redhat{ $name:
        ensure           => $ensure,
        type             => 'package',
        php_version      => $php_version,
        extension_config => $extension_config,
        package_prefix   => $package_prefix,
        meta_package     => $meta_package,
      }
    }
    default: {
      fail("Error - ${module_name}, unsupported OS ${::operatingsytem}")
    }
  }
}
