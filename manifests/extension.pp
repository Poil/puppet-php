define php::extension (
  $ensure,
  $php_version,
) {

  case $::operatingsystem {
    'Ubuntu': {
      ::php::extension::ubuntu { $name:
        ensure      => $ensure,
        php_version => $php_version
      }
    }
    default: {
      fail("Error - ${module_name}, unsupported OS ${::operatingsytem}")
    }
  }
}
