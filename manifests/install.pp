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
  $manage_repo = $::php::manage_repo,
) {

  validate_re($ensure_cli, '^(present)|(installed)|(latest)|(absent)|(purged)$', "ensure_cli is '${ensure_cli}' and must be absent, purged, present, installed or latest")
  validate_re($ensure_mod_php, '^(present)|(installed)|(latest)|(absent)|(purged)$', "ensure_cli is '${ensure_cli}' and must be absent, purged, present, installed or latest ")
  validate_re($ensure_fpm, '^(present)|(installed)|(latest)|(absent)|(purged)$', "ensure_fpm, is '${ensure_cli}' and must be absent, purged, present, installed or latest")

  # --------------------
  # Repo
  # --------------------
  case $repo {
    'distrib': {
    }
    default: {
      case $::osfamily {
        'Debian': {
          $osfamily_min = downcase($::operatingsystem)
        }
        default: {
          $osfamily_min = downcase($::osfamily)
        }
      }
      if $manage_repo {
        include "::php::repo::${osfamily_min}::${repo}"
      }
    }
  }

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

      $_fpm_pools = prefix ($fpm_pools, "${name}##")
      create_resources('::php::fpm::pool', $_fpm_pools, {
        version => $name,
        repo    => $repo,
        notify  => ::Php::Fpm::Service[$name],
        require => [::Php::Fpm::Install[$name], Class['::php::folders']],
        before  => ::Php::Fpm::Logrotate[$name],
      })

      # Purge default www pool if no pool with this name have been defined
      if !empty($fpm_pools, 'fpm_pools') and !has_key($fpm_pools, 'www') {
        ::php::fpm::pool { "${name}##www" :
          ensure    => absent,
          repo      => $repo,
          version   => $name,
          pool_name => 'www',
          require   => [::Php::Fpm::Install[$name], Class['::php::folders']],
          notify    => ::Php::Fpm::Service[$name],
        }
      }

      ::php::fpm::logrotate { $name:
        ensure    => $ensure_fpm,
        repo      => $repo,
        fpm_pools => $fpm_pools,
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
  $_extensions = prefix ($extensions, "${name}##")
  create_resources('::php::extension', $_extensions, {
    repo        => $repo,
    php_version => $name
  })  # Todo : notify apache or/and fpm
}

