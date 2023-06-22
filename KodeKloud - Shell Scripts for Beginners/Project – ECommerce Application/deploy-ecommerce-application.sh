#!/bin/bash

yum install -y firewalld mariadb-server httpd php php-mysql git
systemctl enable --now firewalld
systemctl enable --now mariadb

firewall-cmd --permanent --zone=public --add-port={80,3306}/tcp
firewall-cmd --reload

cat > create-db-user-script.sql <<-EOF
CREATE DATABASE ecomdb;
CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
FLUSH PRIVILEGES;
EOF

mysql < create-db-user-script.sql

cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
EOF

mysql < db-load-script.sql

sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf

systemctl enable --now httpd

git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/

sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php

curl http://localhost