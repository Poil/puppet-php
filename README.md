# PHP
## Introduction
This module is intended to deploy standalone and multiple PHP versions/instances.

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
      * repo : offload global repo parameter 
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
        * meta_package: optional list of modules present and to activate in the package
          * array of module
        * fpm_pools
          * pool name
            * ensure: string present/absent
            * user: run user
            * group: run group
            * listen: string, default empty
            * listen_owner: string, default OS php-fpm user
            * listen_group: string, default OS php-fpm group
            * listen_mode: string, default 0660
            * pm: string, default ondemand
            * pm_max_children: integer, default 5
            * pm_start_servers: integer, default empty
            * pm_min_spare_servers: integer, default 1
            * pm_max_spare_servers : integer, default 3
            * pm_process_idle_timeout: string, default 10s
            * pm_max_requests: integer, default 500
            * log_path: string, default /var/log/php${version}-fpm.${pool_name}
            * custom_pool_config:
              * section (pool name)
                * hash of configuration

```yaml
php::repo: scl
php::versions:
    '5.5':
        repo: distrib
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
### Debian/Ubuntu Sury/Ondrej
Don't use PECL to install the extension, but just download the tarball, unpack, chdir into unpacked dir and run: ```phpize5.5 && ./configure --with-php-config=php-config5.5 && make && sudo make install```
### RedHat Family
To do, use scl enable rh-phpXX pecl install module
