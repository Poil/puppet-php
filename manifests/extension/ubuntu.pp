# == define php::extension::ubuntu
define php::extension::ubuntu (
  $ensure,
  $repo,
  $type,
  $php_version,
  $sapi,
  $extension_config,
  $package_prefix,
  $meta_package,
  $extension_name = $name,
) {
  if ($extension_name == $name) {
    if ($name =~ /^(.+)##(.+)$/) {
      $_extension_name = $2
    } else {
      fail("Error - ${module_name}, Invalid pool name : ${name}")
    }
  } else {
      $_extension_name = $extension_name
  }

  $available_sapi = ['fpm', 'apache2', 'cli']

  $is_mod_php = getparam(Php::Mod_php::Install[$php_version], 'ensure')

  if empty($sapi) {
    $enabling_sapi = $sapi
    $disabling_sapi = difference($available_sapi, $sapi)
  } else {
    $enabling_sapi = ['ALL']
    $disabling_sapi = []
  }

  case $repo {
    'distrib': {
      $config_dir = '/etc/php5'
      $binary_path = '/usr/bin/php5'
      case $::operatingsystemmajrelease {
        '16.04': {
          $_package_prefix = pick($package_prefix, 'php7.0-')
          $ext_tool_enable = "phpenmod -v ${php_version}"
          $ext_tool_disable = "phpdismod -v ${php_version}"
          $ext_tool_query = "phpquery -v ${php_version}"
        }
        '12.04', '14.04': {
          $_package_prefix = pick($package_prefix, 'php5-')
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
      $config_dir = "/etc/php/${_extension_name}"
      $binary_path = "/usr/bin/php${_extension_name}"
      $_package_prefix = pick($package_prefix, "php${php_version}-")
      $ext_tool_enable = "phpenmod -v ${php_version}"
      $ext_tool_disable = "phpdismod -v ${php_version}"
      $ext_tool_query = "phpquery -v ${php_version}"
    }
    default: {
      fail("Error - ${module_name}, Unknown repository ${repo}")
    }
  }
  $package_name = "${_package_prefix}${_extension_name}"

  if ($type == 'package') {
    package { $package_name:
      ensure => $ensure,
    }
    $requirement = Package[$package_name]
  } else {
    $requirement = undef
  }

  # Package that include multiple php module
  if !empty($meta_package) {
    $_meta_package = prefix($meta_package, "${php_version}-module##")
    php::extension::ubuntu { $_meta_package:
      ensure           => $ensure,
      repo             => $repo,
      type             => 'module',
      php_version      => $php_version,
      sapi             => $sapi,
      extension_config => $extension_config,
      package_prefix   => $package_prefix,
      meta_package     => [],
      require          => $requirement,
    }
  } else {
    case $ensure {
      'present', 'installed', 'latest': {
        $default_extension_config = {
          'path' => "${config_dir}/mods-available/${_extension_name}.ini"
        }
        if !empty($extension_config) {
          create_ini_settings($extension_config, $default_extension_config)
        }

        case $is_mod_php {
          'present', 'installed': {
            if !empty($enabling_sapi) {
              $p_enabling_sapi = prefix($enabling_sapi, "enabling/${php_version}/${_extension_name}/")
              ::php::extension::sapi { $p_enabling_sapi:
                ensure           => present,
                module           => $_extension_name,
                ext_tool_query   => $ext_tool_query,
                ext_tool_enable  => $ext_tool_enable,
                ext_tool_disable => $ext_tool_disable,
                notify           => Service[$::php::apache_service_name],
                require          => $requirement,
              }
            }
            if !empty($disabling_sapi) {
              $p_disabling_sapi = prefix($disabling_sapi, "disabling/${php_version}/${_extension_name}/")
              ::php::extension::sapi { $p_disabling_sapi:
                ensure           => absent,
                module           => $_extension_name,
                ext_tool_query   => $ext_tool_query,
                ext_tool_enable  => $ext_tool_enable,
                ext_tool_disable => $ext_tool_disable,
                notify           => Service[$::php::apache_service_name],
                require          => $requirement,
              }
            }
          }
          default : {
            if !empty($enabling_sapi) {
              $p_enabling_sapi = prefix($enabling_sapi, "enabling/${php_version}/${_extension_name}/")
              ::php::extension::sapi { $p_enabling_sapi:
                ensure           => present,
                module           => $_extension_name,
                ext_tool_query   => $ext_tool_query,
                ext_tool_enable  => $ext_tool_enable,
                ext_tool_disable => $ext_tool_disable,
                require          => $requirement,
              }
            }
            if !empty($disabling_sapi) {
              $p_disabling_sapi = prefix($disabling_sapi, "disabling/${php_version}/${_extension_name}/")
              ::php::extension::sapi { $p_disabling_sapi:
                ensure           => absent,
                module           => $_extension_name,
                ext_tool_query   => $ext_tool_query,
                ext_tool_enable  => $ext_tool_enable,
                ext_tool_disable => $ext_tool_disable,
                require          => $requirement,
              }
            }
          }
        }
      }
      'absent', 'purged': {
        file { "${config_dir}/mods-available/${_extension_name}.ini":
          ensure => absent
        }
      }
      default: {
        fail("Error - ${module_name}, unknown ensure value '${ensure}'")
      }
    }
  }
}
