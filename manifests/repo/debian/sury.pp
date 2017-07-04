# Configure debian sury repository
#
# === Parameters
#
# [*ensure*]
#   Ensure present/absent
#
class php::repo::debian::sury (
  $ensure = 'present'
) {
  if $caller_module_name != $module_name {
    warning('php::repo::debian::sury is private')
  }

  $versions_keys = keys($::php::versions)

  include '::apt'
  ensure_packages(['apt-transport-https'])

  ::apt::source { 'php-sury':
    ensure   => $ensure,
    location => 'https://packages.sury.org/php/',
    release  => $::lsbdistcodename,
    repos    => 'main',
    key      => {
      id     => 'DF3D585DB8F0EB658690A554AC0E47584A7A714D',
      server => 'pgp.mit.edu',
    }
  }

}
