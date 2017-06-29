# == define php::extension::redhat
define php::extension::redhat (
  $ensure,
  $repo,
  $type,
  $php_version,
  $extension_config,
  $package_prefix,
  $meta_package,
) {
  $is_mod_php = getparam(Php::Mod_php::Install[$php_version], 'ensure')
  $stripped_version = regsubst(sprintf('%s', $php_version), '\.', '')

  case $repo {
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
          $_package_prefix = pick($package_prefix, "rh-php${stripped_version}-php-")
        }
        '7.0': {
          $config_dir = '/etc/opt/rh/rh-php70/php.d'
          $binary_path = '/opt/rh/rh-php70/root/usr/bin/php'
          $_package_prefix = pick($package_prefix, "rh-php${stripped_version}-php-")
        }
        default: {
        }
      }
    }
    default: {
      fail("Error - ${module_name}, Unknown repository ${repo}")
    }
  }
  $extension_name = "${_package_prefix}${name}"

  if ($type == 'package') {
    package { $extension_name:
      ensure => $ensure,
    }
  }
}
