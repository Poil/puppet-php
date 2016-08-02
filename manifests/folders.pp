class php::folders {
  if !defined(File[$::php::tmp_path]) {
    file { $::php::tmp_path:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '1777',
    }
  }

  if $::php::session_save_path and !defined(File[$::php::session_save_path]) {
    file { $::php::session_save_path:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '1733',
    }
  }

  # Manage log directory if not the default one (/var/log)
  if $::php::log_path != $::php::params::log_path {
    file { $::php::log_path :
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }
}
