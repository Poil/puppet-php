define php::extension::sapi (
  $ensure,
  $module,
  $ext_tool_query,
  $ext_tool_enable,
  $ext_tool_disable,
) {
  case $ensure {
    'absent' : {
      exec { "${ext_tool_disable} -m ${module} -s ${name}":
        onlyif  => "${ext_tool_query} -s ${name} -m ${name}",
      }
    }
    'present' : {
      exec { "${ext_tool_enable} -m ${module} -s ${name}":
        unless  => "${ext_tool_query} -s ${name} -m ${name}",
      }
    }
    default : {
      fail("Error - ${module_name}, unknown ensure value ${ensure}")
    }
  }
}

