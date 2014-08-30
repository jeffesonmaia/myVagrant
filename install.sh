#!/usr/bin/env bash

# Variables
DBHOST=192.168.33.10
DBNAME=test
DBUSER=root
DBPASSWD=1234

echo "--- Good morning, master. Let's get to work. Installing now. ---"

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- Installing base packages ---"
sudo apt-get install -y vim curl python-software-properties build-essential git

echo "--- MySQL time ---"
sudo echo "mysql-server mysql-server/root_password password $DBPASSWD" | debconf-set-selections
sudo echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | debconf-set-selections

sudo apt-get install mysql-server-5.5 libmysqlclient-dev -y

echo -e "\n--- Setting up our MySQL user and db ---\n"
mysql -u$DBUSER -p$DBPASSWD -e "CREATE DATABASE IF NOT EXISTS $DBNAME"
mysql -u$DBUSER -p$DBPASSWD -e "GRANT ALL PRIVILEGES ON *.* TO '$DBUSER'@'%' IDENTIFIED BY '$DBPASSWD' WITH GRANT OPTION; FLUSH PRIVILEGES;"
sed -i "s/bind-address.*/bind-address            = 0.0.0.0/" /etc/mysql/my.cnf
sudo service mysql restart

echo "--- We want the bleeding edge of PHP, right master? ---"
sudo add-apt-repository -y ppa:ondrej/php5

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- Installing PHP-specific packages ---"
sudo apt-get install php5 php5-mcrypt php5-intl php5-mysql php5-sqlite php5-pgsql php5-curl php5-xdebug php5-gd php5-geoip php5-mcrypt php5-redis php5-memcache php5-memcached -y

echo -e "\n--- Enabling mod-rewrite ---\n"
sudo a2enmod rewrite > /dev/null 2>&1

echo -e "\n--- Allowing Apache override to all ---\n"
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

echo -e "\n--- We definitly need to see the PHP errors, turning them on ---\n"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

#sudo chown -R vagrant:vagrant /var/lib/php5/
#chown apache /var/lib/php5/sessions
#chmod 700 /var/lib/php5/sessions
#sed -i "s/;session.save_path = \"/var/lib/php5\"/session.save_path = \"/var/lib/php5/sessions\"/" /etc/php5/apache2/php.ini
#sed -i "s/;session.save_path = .*/session.save_path = '/var/lib/php5/sessions'/" /etc/php5/apache2/php.ini
sudo echo "session.save_path = \"/var/lib/php5/sessions\"" >> /etc/php5/apache2/php.ini
sudo service apache2 restart

echo -e "\n--- Installing Composer for PHP package management ---\n"
curl --silent https://getcomposer.org/installer | php > /dev/null 2>&1
mv composer.phar /usr/local/bin/composer

#echo -e "\n--- Installing Node ---\n"
#cd /tmp
#wget http://nodejs.org/dist/v0.10.31/node-v0.10.31.tar.gz
#tar xvzf node-v0.10.31.tar.gz
#cd node-v0.10.31
#./configure
#make
#sudo make install
#cd /tmp
#rm -rf node-v0.10.31.tar.gz node-v0.10.31

#echo -e "\n--- Installing Node ---\n"
#sudo add-apt-repository ppa:chris-lea/node.js
#sudo apt-get update
#sudo apt-get install nodejs -y
