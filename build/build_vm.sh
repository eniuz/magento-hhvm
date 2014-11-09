#!/usr/bin/env bash

apt-get update
apt-get install python-software-properties  -y --force-yes
add-apt-repository ppa:mapnik/boost
add-apt-repository ppa:nginx/stable
wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
echo deb http://dl.hhvm.com/ubuntu precise main | sudo tee /etc/apt/sources.list.d/hhvm.list
apt-get update
apt-get install nginx -y --force-yes
apt-get install hhvm-nightly -y --force-yes
apt-get install screen vim -y --force-yes
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password pa$$'
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password pa$$'
apt-get install mysql-server -y --force-yes

sudo chown vagrant /etc/hhvm
sudo cp /vagrant/conf/config.hdf /etc/hhvm/my-config.hdf
sudo cp /vagrant/conf/php.ini /etc/hhvm/my-php.ini
sudo rm /etc/nginx/sites-enabled/default
sudo cp /vagrant/conf/nginx-fastcgi /etc/nginx/sites-available/nginx-fastcgi
sudo ln -s /etc/nginx/sites-available/nginx-fastcgi /etc/nginx/sites-enabled/nginx-fastcgi
sudo service nginx restart

hhvm -m daemon -c /etc/hhvm/my-php.ini -v Eval.EnableXHP=1

# Create database
mysql -uroot -p'pa$$' -e "CREATE DATABASE IF NOT EXISTS magento;"
mysql -uroot -p'pa$$' magento < /vagrant/build/magento.sql
