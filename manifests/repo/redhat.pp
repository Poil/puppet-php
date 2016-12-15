# == class php::repo::redhat
class php::repo::redhat (
  $ensure = 'present'
) {
  file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo':
    ensure => present,
    source => "puppet:///modules/${module_name}/gpg/RPM-GPG-KEY-CentOS-SIG-SCLo",
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  case $::operatingsystem {
    'CentOS', 'OracleLinux': {
      yumrepo { "CentOS-${::operatingsystemmajrelease}-SCLo":
        descr    => 'CentOS-SCLo-rh.repo',
        baseurl  => "${::php::centos_mirror_url}/centos/${::operatingsystemmajrelease}/sclo/\$basearch/rh/",
        gpgcheck => 1,
        enabled  => 1,
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo',
        require  => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo'],
      }
    }
    default : {
    }
  }
  yumrepo { "CentOS-${::operatingsystemmajrelease}-SCLo-scl":
    descr    => 'CentOS-SCLo-scl.repo',
    baseurl  => "${::php::centos_mirror_url}/centos/${::operatingsystemmajrelease}/sclo/\$basearch/sclo/",
    gpgcheck => 1,
    enabled  => 1,
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo',
    require  => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo'],
  }
}

