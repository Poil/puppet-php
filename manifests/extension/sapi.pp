# == define php::extension::sapi
define php::extension::sapi (
  $ensure,
  $module,
  $ext_tool_query,
  $ext_tool_enable,
  $ext_tool_disable,
) {
  $sapi_tmp = split($name, '/')
  $sapi = $sapi_tmp[3]

  case $sapi {
    'ALL' : {
      case $ensure {
        'absent' : {
          exec { "${ext_tool_query} -S | xargs -I {} ${ext_tool_disable} -s {} -m ${module}":
            onlyif  => "${ext_tool_query} -S | xargs -I {} ${ext_tool_query} -s {} -m ${module} | grep Enabled",
          }
        }
        'present' : {
          exec { "${ext_tool_query} -S | xargs -I {} ${ext_tool_enable} -s {} -m ${module}":
            unless => "${ext_tool_query} -S | xargs -I {} ${ext_tool_query} -s {} -m ${module} | grep Enabled",
          }
        }
        default : {
          fail("Error - ${module_name}, unknown ensure value ${ensure}")
        }
      }
    }
    default : {
      case $ensure {
        'absent' : {
          exec { "${ext_tool_disable} -s ${sapi} -m ${module}":
            onlyif  => "${ext_tool_query} -s ${sapi} -m ${module} | grep Enabled",
          }
        }
        'present' : {
          exec { "${ext_tool_enable} -s ${sapi} -m ${module}":
            unless  => "${ext_tool_query} -s ${sapi} -m ${module} | grep Enabled",
          }
        }
        default : {
          fail("Error - ${module_name}, unknown ensure value ${ensure}")
        }
      }
    }
  }
}

