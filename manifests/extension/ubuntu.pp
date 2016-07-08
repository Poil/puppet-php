define php::extension::ubuntu (
  $ensure,
  $php_version,
  $sapi = [],
  $extension_config = {},
) {
  $available_sapi = ['fpm', 'apache2', 'cli']

  if empty($sapi) {
    $enabling_sapi = $sapi
    $disabling_sapi = difference($available_sapi, $sapi)
  } else {
    $enabling_sapi = ['ALL']
    $disabling_sapi = []
  }

  case $::php::repo {
    'distrib': {
      $config_dir = '/etc/php5'
      $binary_path = '/usr/bin/php5'
      case $::operatingsystemmajrelease {
        '16.04': {
          $package_prefix = 'php7-'
          $ext_tool_enable = 'phpenmod'
          $ext_tool_disable = 'phpdismod'
          $ext_tool_query = 'phpquery'
        }
        '14.04': {
          $package_prefix = 'php5-'
          $ext_tool_enable = 'php5enmod'
          $ext_tool_disable = 'php5dismod'
          $ext_tool_query = 'php5query'
        }
        default: {
          fail("Error - ${module_name}, Unknown OSRelease ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    'ondrej': {
      $config_dir = "/etc/php/${name}"
      $binary_path = "/usr/bin/php${name}"
      $package_prefix = "php${php_version}-"
      $ext_tool_enable = "phpenmod -v ${php_version}"
      $ext_tool_disable = "phpdismod -v ${php_version}"
      $ext_tool_query = "phpquery -v ${php_version}"
    }
    default: {
      fail("Error - ${module_name}, Unknown repository ${::php::repo}")
    }
  }
  $extension_name = "${package_prefix}${name}"

  package { $extension_name:
    ensure => $ensure,
  }

  case $ensure {
    'present', 'installed', 'latest': {
      $default_extension_config = {
        'path' => "${config_dir}/mods-available/${name}.ini"
      }
      if !empty($extension_config) {
        create_ini_settings($extension_config, $default_extension_config)
      }

      if !empty($enabling_sapi) {
        $p_enabling_sapi = prefix($enabling_sapi, "enabling/${php_version}/")
        ::php::extension::sapi { $p_enabling_sapi:
          ensure           => present,
          module           => $name,
          ext_tool_query   => $ext_tool_query,
          ext_tool_enable  => $ext_tool_enable,
          ext_tool_disable => $ext_tool_disable,
        }
      }
      if !empty($disabling_sapi) {
        $p_disabling_sapi = prefix($disabling_sapi, "disabling/${php_version}/")
        ::php::extension::sapi { $p_disabling_sapi:
          ensure           => absent,
          module           => $name,
          ext_tool_query   => $ext_tool_query,
          ext_tool_enable  => $ext_tool_enable,
          ext_tool_disable => $ext_tool_disable,
        }
      }
    }
    'absent', 'purged': {
      file { "${config_dir}/mods-available/${name}.ini":
        ensure => absent
      }
    }
    default: {
      fail("Error - ${module_name}, unknown ensure value '${ensure}'")
    }
  }
}
