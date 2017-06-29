# == define php::install
define php::install (
  $ensure_cli = 'present',
  $custom_config_cli = {},
  $ensure_mod_php = 'absent',
  $custom_config_mod_php = {},
  $ensure_fpm = 'absent',
  $ensure_service_fpm = 'running',
  $enable_service_fpm = true,
  $custom_config_fpm = {},
  $fpm_pools = {},
  $extensions = {},
  $repo = $::php::repo,
) {

  validate_re($ensure_cli, '^(present)|(installed)|(latest)|(absent)|(purged)$', "ensure_cli is '${ensure_cli}' and must be absent, purged, present, installed or latest")
  validate_re($ensure_mod_php, '^(present)|(installed)|(latest)|(absent)|(purged)$', "ensure_cli is '${ensure_cli}' and must be absent, purged, present, installed or latest ")
  validate_re($ensure_fpm, '^(present)|(installed)|(latest)|(absent)|(purged)$', "ensure_fpm, is '${ensure_cli}' and must be absent, purged, present, installed or latest")

  # --------------------
  # Repo
  # --------------------
  $osfamily_min = downcase($::osfamily)
  include "::php::repo::${osfamily_min}/${repo}.pp"

  # --------------------
  # FPM
  # --------------------
  case $ensure_fpm {
    'absent', 'purged': {
      ::php::fpm::install { $name:
        ensure => $ensure_fpm,
        before => Class['::php::folders'],
      }
    }
    default : {
      ::php::fpm::install { $name:
        ensure        => $ensure_fpm,
        repo          => $repo,
        custom_config => $custom_config_fpm,
        notify        => ::Php::Fpm::Service[$name],
        before        => Class['::php::folders'],
      }
      ::php::fpm::service { $name:
        ensure  => $ensure_service_fpm,
        repo    => $repo,
        enable  => $enable_service_fpm,
        require => [::Php::Fpm::Install[$name], Class['::php::folders']],
      }

      create_resources('::php::fpm::pool', $fpm_pools, {
        version => $name,
        repo    => $repo,
        notify  => ::Php::Fpm::Service[$name],
        require => [::Php::Fpm::Install[$name], Class['::php::folders']],
      })

      # Purge default www pool if no pool with this name have been defined
      if !empty($fpm_pools, 'fpm_pools') and !has_key($fpm_pools, 'www') {
        ::php::fpm::pool { "${name}-www" :
          ensure    => absent,
          repo      => $repo,
          version   => $name,
          pool_name => 'www',
          require   => [::Php::Fpm::Install[$name], Class['::php::folders']],
          notify    => ::Php::Fpm::Service[$name],
        }
      }
    }
  }

  # --------------------
  # mod_php
  # --------------------
  ::php::mod_php::install { $name:
    ensure        => $ensure_mod_php,
    repo          => $repo,
    custom_config => $custom_config_mod_php,
    before        => Class['::php::folders'],
  }

  # --------------------
  # cli
  # --------------------
  ::php::cli::install { $name:
    ensure        => $ensure_cli,
    repo          => $repo,
    custom_config => $custom_config_cli,
    before        => Class['::php::folders'],
  }

  # --------------------
  # modules
  # --------------------
  create_resources('::php::extension', $extensions, {
    repo        => $repo,
    php_version => $name
  })  # Todo : notify apache or/and fpm
}

