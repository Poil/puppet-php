# Configure ubuntu ppa
#
# === Parameters
#
# [*ensure*]
#   Ensure present/absent
#
class php::repo::ubuntu::ondrej (
  $ensure = 'present'
) {
  if $caller_module_name != $module_name {
    warning('php::repo::ubuntu is private')
  }

  ensure_packages(['python-software-properties', 'software-properties-common'])

  $versions_keys = keys($::php::versions)

  include '::apt'

  ::apt::ppa { 'ppa:ondrej/php':
    ensure  => $ensure,
    require => Package['software-properties-common']
  }
}

