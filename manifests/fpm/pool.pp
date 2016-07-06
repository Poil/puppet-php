# == define php::fpm::pool
define php::fpm::pool (
  $version,
  $ensure,
  $user = $::php::fpm_user,
  $group = $::php::fpm_group,
  $php_admin_values = {},
  $php_admin_flags = {},
  $php_values = {},
  $php_flags = {},
) {
}


