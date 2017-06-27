# == class php::repo::debian
class php::repo::debian ($ensure = 'distrib') {
  case $ensure {
    'distrib': {
      class { '::php::repo::debian::sury': ensure => absent }
    }
    'sury': {
      class { '::php::repo::debian::sury': ensure => present }
    }
    default: {
      fail("Error - ${module_name}, unknown repo ${ensure}")
    }
  }
}
