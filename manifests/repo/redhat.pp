# == class php::repo::redhat
class php::repo::redhat (
  $ensure = 'present'
) {
  file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo':
    ensure => present,
    source => "puppet:///modules/${module_name}/gpg/RPM-GPG-KEY-CentOS-SIG-SCLo",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  yumrepo { "CentOS-${::operatingsystemmajrelease}-SCLo":
    descr    => 'CentOS-SCLo-rh.repo',
    baseurl  => "${::php::centos_mirror_url}/centos/\$releasever/sclo/\$basearch/rh/",
    gpgcheck => 1,
    enabled  => 1,
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo',
    require  => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo'],
  }
}
