# Configure ubuntu ppa
#
# === Parameters
#
# [*ensure*]
#   Ensure present/absent
#
class php::repo::ubuntu (
  $ensure = 'present'
) {
  if $caller_module_name != $module_name {
    warning('php::repo::ubuntu is private')
  }

  $versions_keys = keys($::php::versions)
  if intersection($versions_keys, ['5.6' , '5.7', '7.0', '7.1']) == $versions_keys {
    fail("Error - ${module_name} versions ${versions_keys} are not supported by ondrej repository")
  }

  include '::apt'

  ::apt::ppa { 'ppa:ondrej/php': ensure => $ensure }
}

