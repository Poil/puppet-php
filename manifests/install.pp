# == define php::install
define php::install (
  $ensure_cli = true,
  $cli_conf = {},
  $ensure_mod_php = false,
  $mod_php_conf = {},
  $ensure_fpm = absent,
  $fpm_conf = {},
  $fpm_pool = {},
  $modules = {},
  $version = $name,
) {
  php::fpm::install { $name:
    ensure  => $ensure_fpm,
    version => $version,
  }

  create_resources(ini_setting, $fpm_conf, $::php::default_fpm_conf)

  create_resources('php::fpm::pool', $fpm_pool)
}
