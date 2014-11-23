name "webserver"
description "Role for web servers"

run_list(
  "recipe[apt]",
  "recipe[vim]",
  "recipe[mysql::server]"
)
