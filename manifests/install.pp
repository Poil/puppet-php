# == define php::install
define php::install (
  $ensure_cli = present,
  $custom_config_cli = {},
  $ensure_mod_php = absent,
  $custom_config_mod_php = {},
  $ensure_fpm = absent,
  $ensure_service_fpm = 'running',
  $enable_service_fpm = true,
  $custom_config_fpm = {},
  $fpm_pools = {},
  $modules = {},
) {

  validate_re($ensure_cli, '^(present)|(installed)|(absent)$', "ensure_cli is '${ensure_cli}' and must be absent, present or installed")
  validate_re($ensure_mod_php, '^(present)|(installed)|(absent)$', "ensure_cli is '${ensure_cli}' and must be absent, present or installed")
  validate_re($ensure_fpm, '^(present)|(installed)|(absent)$', "ensure_fpm, is '${ensure_cli}' and must be absent, present or installed")

  ::php::fpm::install { $name:
    ensure         => $ensure_fpm,
    custom_config  => $custom_config_fpm,
  }

  ::php::fpm::service { $name:
    ensure => $ensure_service_fpm,
    enable => $enable_service_fpm,
  }

  create_resources('::php::fpm::pool', $fpm_pools, { 'version' => $name, notify => Service['::php::fpm::service'], })

  # Purge default www pool if no pool with this name have been defined
  if !empty($fpm_pools, 'fpm_pools') and !has_key($fpm_pools, 'www') {
    ::php::fpm::pool { "${name}-www" :
      ensure    => absent,
      version   => $name,
      pool_name => 'www',
    }
  }
}
