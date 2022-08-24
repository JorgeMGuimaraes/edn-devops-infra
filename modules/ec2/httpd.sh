#! /bin/bash

apt update
apt install -y apache2
systemctl start apache2
systemctl enable apache2
echo "<h1>OLA MUNDO DE $(hostname -f)</h1>" > /var/www/html/index.html

adduser ubuntu www-data
chown -R ubuntu:www-data /var/www
chmod -R 755 /var/www/html