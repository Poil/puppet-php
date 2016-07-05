# == define php::install
define php::install (
  $ensure_cli = present,
  $cli_conf = {},
  $ensure_mod_php = absent,
  $mod_php_conf = {},
  $ensure_fpm = absent,
  $fpm_conf = {},
  $fpm_pool = {},
  $modules = {},
) {

  validate_re($ensure_cli, '^(present)|(installed)|(absent)$', "ensure_cli is '${ensure_cli}' and must be absent, present or installed")
  validate_re($ensure_mod_php, '^(present)|(installed)|(absent)$', "ensure_cli is '${ensure_cli}' and must be absent, present or installed")
  validate_re($ensure_fpm, '^(present)|(installed)|(absent)$', "ensure_fpm, is '${ensure_cli}' and must be absent, present or installed")

  php::fpm::install { $name:
    ensure  => $ensure_fpm,
  }

  create_resources(ini_setting, $fpm_conf, $::php::default_fpm_conf)

  create_resources('php::fpm::pool', $fpm_pool)
}
