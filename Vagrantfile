# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 3306, host: 3306
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder "./www", "/var/www/html", :nfs => false, owner: "www-data", group: "www-data"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
    vb.cpus = 2
  end
  
  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = "./cookbooks"
    chef.custom_config_path = "Vagrantfile.chef"
    
    chef.add_recipe "apt"
    chef.add_recipe "vim"
    chef.add_recipe "mysql::server"
    chef.add_recipe "apache2"
    chef.add_recipe "php"
    chef.add_recipe "composer"
    chef.add_recipe "git"
    chef.add_recipe "nodejs"
    chef.add_recipe "rvm::user"  

    chef.json = {
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
          'php5-cgi', 'php5', 'php5-dev', 'php5-cli', 'php-pear', 'php5-mcrypt', 'php5-mysql',
          'php5-odbc', 'php5-sybase', 'php5-intl', 'php5-xdebug', 'php5-sqlite'
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
      },
      'rvm' => {
        'user_installs' => [{        
          'user' => 'vagrant',
          'default_ruby' => 'ruby-1.9.3-p551@193gemset'
        }]
      }
    }
  end
end
