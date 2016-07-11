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

  include '::apt'

  ::apt::ppa { 'ppa:ondrej/php': ensure => $ensure }
}

