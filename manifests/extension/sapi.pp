define php::extension::sapi (
  $ensure,
  $module,
  $ext_tool_query,
  $ext_tool_enable,
  $ext_tool_disable,
) {
  $sapi_tmp = split($name, '/')
  $sapi = $sapi_tmp[2]
  case $ensure {
    'absent' : {
      exec { "${ext_tool_disable} -m ${module} -s ${sapi}":
        onlyif  => "${ext_tool_query} -s ${sapi} -m ${module} | grep Enabled",
      }
    }
    'present' : {
      exec { "${ext_tool_enable} -m ${module} -s ${sapi}":
        unless  => "${ext_tool_query} -s ${sapi} -m ${module} | grep Enabled",
      }
    }
    default : {
      fail("Error - ${module_name}, unknown ensure value ${ensure}")
    }
  }
}

