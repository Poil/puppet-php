# PHP
## Introduction
This module is intended to deploy standalone and multiple PHP version.

## Parameters
* repo : 
  * Debian :
    * distrib : standalone
    * sury : multiple
    * dotdeb : standalone
  * Ubuntu :
    * distrib : standalone
    * ondrej : multiple
  * RedHat :
    * distrib : standalone
    * scl : multiple
* versions
  * Format :
    * versions : string
      * ensure_cli : string present/absent
      * ensure_mod_php : string present/absent
      * ensure_fpm : string present/absent  
      * custom_config_fpm:
        * section
          * key: value
      * extensions:
        * name
          * ensure : string present/absent
          * sapi :
            * 
        * fpm_pools
  * Example :
    * pool name :
      * ensure : string present/absent
      * user
      * group
      * custom_pool_config:

```yaml
php::versions:
    '5.5':
        ensure_cli: present
        ensure_mod_php: present
        ensure_fpm: purged
    '5.6':
        ensure_cli: present
        ensure_mod_php: purged
        ensure_fpm: present
        custom_config_fpm: # Custom conf fpm/php.ini mergée avec le hash par défaut
            PHP: # Section PHP du .ini
                display_errors: 'On'
                short_open_tag: 'Off'
        extensions:
            soap:
                ensure: present
            xml:
                ensure: present
                sapi:
                    - fpm
        fpm_pools:
            monitoring56:
                ensure: present
            mypooltwo:
                ensure: present
                user: mydeployuser
                group: www-data
                custom_pool_config:
                    mypooltwo:
                        'php_admin_flag[allow_url_fopen]': 'true'
    7.0:
        ensure_cli: present
        ensure_mod_php: purged
        ensure_fpm: present
        extensions:
            snmp:
                ensure: present
        fpm_pools:
            monitoring70:
                ensure: present
            mypoolone:
                ensure: present
                user: mydeployuser
                group: www-data
                custom_pool_config:
                    mypoolone:
                       'php_admin_flag[allow_url_fopen]': 'true'
```

# NOTES
## PECL
Don't use PECL to install the extension, but just download the tarball, unpack, chdir into unpacked dir and run: phpize5.5 && ./configure --with-php-config=php-config5.5 && make && sudo make install
