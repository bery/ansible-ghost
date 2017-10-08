Ghost
=========

Installs Ghost, a blogging platform using Ghost CLI. By default it'll install the latest Ghost version available from [Ghost's homepage](https://ghost.org).

By default, it installs 6.x NodeJs version available on [Nodesource's repository](https://deb.nodesource.com/node/) using the [geerlingguy.nodejs](https://github.com/geerlingguy/ansible-role-nodejs) role.

By default, it installs and configures Nginx proxy using the [geerlingguy.nginx](https://github.com/geerlingguy/ansible-role-nginx) role.

By default, it installs and configures Perconna database [tersmitten.percona-server](https://github.com/Oefenweb/ansible-percona-server) role.

All of this is possible because of Ghost's CLI tools. For more reference see [the repo](https://github.com/TryGhost/Ghost-CLI) or the [docs](https://docs.ghost.org/v1/docs/ghost-cli).

Requirements
------------

* Role is tested and developed for Ubuntu Xenial (16.04 LTS).
* Mailgun account for production.
* See role dependencies for more info.

Installation modes
--------------
* Production [default] - full blown LEMP stack with SSL proxy, **requires valid domain name**
* Local - useful for development, without LEMP stack and SSL or nginx proxy (http://localhost:2368)
* Non-production with stack - useful for development, without LEMP stack (http://localhost)

Role Variables
--------------

* `ghost_install_local: False` - development installations only, install blog on http://localhost:2368 (or next free port)
* `ghost_setup_skip_ssl: False` - skip SSL cert installation - good for stack testing without SSL [http://localhost]
* `ghost_letsencrypt_user: user@example.com` - email for LE notifications and consent
* `ghost_project_domain: localhost` - default domain
* `ghost_project_url: "http://{{ ghost_project_domain }}"` - unsecure URL
* `ghost_project_url_secure: "https://{{ ghost_project_domain }}"` - secure URL
* `ghost_user_name: ghost` - default system user - DO NOT CHANGE
* `ghost_user_group: ghost` - default system group - DO NOT CHANGE
* `ghost_db: mysql` - DB host, can be sqlite3
* `ghost_db_host: localhost` 
* `ghost_db_user: "{{ ghost_user_name }}"` - currently gerenated from domain name
* `ghost_db_name: "{{ ghost_user_name }}"` - currently gerenated from domain name
* `ghost_db_password: "{{ ghost_db_user }}"` - currently gerenated from domain name and stored in files/db_credentials/
* `ghost_smtp: SMTP` - SMTP service 
* `ghost_smtp_service: Mailgun` - use Mailgun as default service see [docs](https://docs.ghost.org/v1/docs/mail-config)
* `ghost_smtp_user: ''` - postmaster@yourdomain.com
* `ghost_smtp_password: ''` - default password for postmaster@yourdomain.com 
* `ghost_smtp_port: 2525` - alternative Mailgun port that works on Google Compute Engine (by default Mailgun uses TCP 587)
* `ghost_install_dir: "/var/www/users/{{ ghost_user_name }}/{{ ghost_project_domain }}"` - install directory
* `ghost_cli_version: 1.1.1`

Uninstalling Ghost
--------------
* `ghost_uninstall` set to True
* run the playbook in `ghost_install_dir`

Using custom themes
--------------
* `ghost_themes` is a dictonary and when defined a custom theme will be installed to the themes directory
```
ghost_themes:
      blog:
        ghost_custom_theme_name: "blog"
        ghost_custom_theme_repo: "https://github.com/TryGhost/Blog.git"
        ghost_custom_theme_version: "master"
        ghost_custom_theme_accept_hostkey: false
        ghost_custom_theme_key_file: None
```
* for more examples see playbooks in tests directory

Future work
--------------
* travis tests
* support updates [with custom themes]
* new relic support
* add nginx pagespeed support
* resolve nginx redirects to SSL
* make SSL installation faster (populating dhparam file takes long time)
* support more CLI features as they are added

Dependencies
------------

* [geerlingguy.nodejs](https://github.com/geerlingguy/ansible-role-nodejs) role.
* [geerlingguy.nginx](https://github.com/geerlingguy/ansible-role-nginx) role.
* [tersmitten.percona-server](https://github.com/Oefenweb/ansible-percona-server) role.


These roles can be installed by running `ansible-galaxy install -r tests/requirements.yml`.

Testing
-------
* `vagrant up` 
* `./test.sh` 

Advanced Testing using Docker
-------
* see tests/README.md 

Example Playbook
----------------

    - hosts: servers
      roles:
         - bery.ghost

License
-------

BSD

Author Information
------------------

Thanks to [Manuel Tiago Pereira](http://mtpereira.github.io) for original role.

Thanks to [Jeff Geerling](https://github.com/geerlingguy) for both Nginx and NodeJs roles.

Thanks to [Oefenweb.nl](https://github.com/Oefenweb) for both Nginx and NodeJs roles.

[GitHub project page](https://github.com/bery/ansible-ghost)

