# == define php::config
define php::config(
  $default_config = {},
  $custom_config = {}
) {
  create_ini_settings($custom_config, $default_config)
}
