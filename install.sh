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
sudo apt-get install -y vim curl python-software-properties build-essential

echo "--- MySQL time ---"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password $DBPASSWD'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $DBPASSWD'
sudo apt-get install mysql-server-5.5 -y

echo -e "\n--- Setting up our MySQL user and db ---\n"
mysql -uroot -p$DBPASSWD -e "CREATE DATABASE IF NOT EXISTS $DBNAME"
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'$DBHOST' identified by '$DBPASSWD'"

echo "--- We want the bleeding edge of PHP, right master? ---"
sudo add-apt-repository -y ppa:ondrej/php5

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- Installing PHP-specific packages ---"
sudo apt-get install php5 -y

echo "--- Installing PHPMYADMIN packages ---"
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'﻿
sudo apt-get install phpmyadmin -y

echo -e "\n--- Enabling mod-rewrite ---\n"
sudo a2enmod rewrite > /dev/null 2>&1

echo -e "\n--- Allowing Apache override to all ---\n"
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

echo -e "\n--- We definitly need to see the PHP errors, turning them on ---\n"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

echo -e "\n--- Configure Apache to use phpmyadmin ---\n"
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/sites-available/phpmyadmin.conf
sudo a2ensite phpmyadmin
sudo service apache2 reload

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

echo -e "\n--- Installing RVM ---\n"
