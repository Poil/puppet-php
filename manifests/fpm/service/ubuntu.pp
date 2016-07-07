define php::fpm::service::ubuntu (
  $ensure,
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

  service { $service_name:
    ensure => $ensure,
  }
}
