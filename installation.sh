#!/bin/bash
 
echo "Updating Apt Packages and upgrading latest patches"
sudo apt-get update -y 
sudo apt-get upgrade -y

echo "Create Team Users and grant root privileges"
sudo adduser mjc18171
sudo usermod -aG sudo mjc18171
passwd --delete mjc18171
cp .keys/id_ed25519.pub /home/mjc18171/.ssh
 
sudo adduser stefk
sudo usermod -aG sudo stefk
passwd --delete steff
 
sudo adduser krr74113
sudo usermod -aG sudo
passwd --delete krr74113
 
sudo adduser msn60002
sudo usermod -aG sudo
passwd --delete msn60002

#cp authorized keys into root
cp .keys/authorized_keys /root/.ssh
 
echo "Installing Apache2 Web server"
sudo apt-get install apache2 -y
 
echo "Installing MySQL"
sudo apt-get install mysql-server -y
mysql -u root -p

#copy apache2 config file
cp .apache2_files/apache2.conf /etc/apache2

echo "Installing PHP"

#this is install will prompt you, select apache2
#another prompt will come up, select yes
sudo apt-get install phpmyadmin -y
mysql -u root -p

#copy php apache2 config file
cp .php_files/php.ini /etc/php/7.4/apache2

#create an admin account to access phpmyadmin
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'COMP424';
GRANT ALL PRIVILEGES ON * . * TO 'admin'@'localhost';
FLUSH PRIVILEGES;
exit

sudo apt-get install php -y
#add php files to /var/www/html unless you alias/redirect to it

echo "Enabling Modules"
sudo a2enmod alias
sudo phpenmod mcrypt
sudo a2enmod ssl
sudo a2enmod headers
sudo a2ensite default-ssl
 
echo "Restarting Apache\n"
sudo service apache2 restart
 
echo "Installing iptables"
sudo apt-get install iptables

echo "Installing Snort"


echo "Installing OpenSSH"
sudo apt-get install openssh

echo 

exit 0