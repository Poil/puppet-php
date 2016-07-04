define php::fpm::install::ubuntu (
  $repo,
  $version
) {
  case $repo {
    'distrib': {
      $package_name = 'php5-fpm'
      $config_dir = '/etc/php5'
      $binary_path = '/usr/bin/php5'
    }
    'ondrej': {
      $package_name = "php${version}-fpm"
      $config_dir = "/etc/php/${version}"
      $binary_path = "/usr/bin/php${version}"
    }
    default: {
      fail("error - ${module_name} unknown repository ${repo}")
    }
  }

  package { $package_name:
    ensure => installed
  }
}
