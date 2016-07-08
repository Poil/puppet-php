# == define php::extension
define php::extension (
  $ensure,
  $php_version,
  $sapi = 'ALL',
) {

  case $::operatingsystem {
    'Ubuntu': {
      ::php::extension::ubuntu { $name:
        ensure      => $ensure,
        php_version => $php_version,
        sapi        => $sapi,
      }
    }
    default: {
      fail("Error - ${module_name}, unsupported OS ${::operatingsytem}")
    }
  }
}
