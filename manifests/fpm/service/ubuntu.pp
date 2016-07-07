define php::fpm::service::ubuntu (
  $ensure,
  $enable,
) {
  case $::php::repo {
    'distrib': {
      $service_name = 'php5-fpm'
    }
    'ondrej': {
      $service_name = "php${name}-fpm"
    }
    default: {
      fail("error - ${module_name} unknown repository ${::php::repo}")
    }
  }

  service { $package_name:
    ensure => $ensure,
    enable => $enable,
  }
}
