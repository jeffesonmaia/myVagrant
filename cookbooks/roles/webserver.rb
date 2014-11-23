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
  }
)

run_list(
  "recipe[apt]",
  "recipe[vim]",
  "recipe[mysql::server]",
  "recipe[php]"
)
