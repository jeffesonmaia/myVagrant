name "webserver"
description "Role for web servers"

override_attributes(
  'mysql' => {
  	'server_root_password' => '1234',
	'server_debian_password' => '1234',
	'server_repl_password' => '1234',
    'port' => '3306',
    'data_dir' => '/opt/local/lib/mysql',
    'allow_remote_root' => true,
    'remove_anonymous_users' => true,
    'remove_test_database'=> true
  },
  'php' => {
    'packages' => [
      'php5-cgi', 'php5', 'php5-dev', 'php5-cli', 'php-pear', 'php5-mcrypt'
    ]
  },
  'apache' => {
  	'default_modules' => [
  	  'status', 'alias', 'auth_basic', 'authn_core', 'authn_file', 'authz_core', 'authz_groupfile',
  	  'authz_host', 'authz_user', 'autoindex', 'dir', 'env', 'mime', 'negotiation', 'setenvif', 
  	  'php5', 'rewrite'
  	],
  	'default_site_enabled' => true,
  	'docroot_dir' => '/var/www/html'
  }
)

run_list(
  "recipe[apt]",
  "recipe[vim]",
  "recipe[mysql::server]",
  "recipe[apache2]",
  "recipe[php]",
  "recipe[composer]"
)
