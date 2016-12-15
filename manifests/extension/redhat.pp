# == define php::extension::redhat
define php::extension::redhat (
  $ensure,
  $type,
  $php_version,
  $extension_config,
  $package_prefix,
  $meta_package,
) {
  $is_mod_php = getparam(Php::Mod_php::Install[$php_version], 'ensure')

  case $::php::repo {
    'distrib': {
      $config_dir = '/etc/php.d'
      $binary_path = '/bin/php'
      case $::operatingsystemmajrelease {
        '6', '7': {
          $_package_prefix = pick($package_prefix, 'php-')
        }
        default: {
          fail("Error - ${module_name}, Unknown OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'scl': {
      case $php_version {
        '5.6': {
          $config_dir = '/etc/opt/rh/rh-php56/php.d'
          $binary_path = '/opt/rh/rh-php56/root/usr/bin/php'
          $_package_prefix = pick($package_prefix, "rh-php${php_version}-")
        }
        default: {
        }
      }
    }
    default: {
      fail("Error - ${module_name}, Unknown repository ${::php::repo}")
    }
  }
  $extension_name = "${_package_prefix}${name}"

  if ($type == 'package') {
    package { $extension_name:
      ensure => $ensure,
    }
  }
}
