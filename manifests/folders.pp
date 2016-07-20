class php::folders {
  file { $::php::tmp_path:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '1777',
  }

  file { $::php::session_save_path:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '1733',
  }
}
