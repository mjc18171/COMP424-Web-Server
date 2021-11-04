#!/bin/bash
 
echo "Updating Apt Packages and upgrading latest patches"
echo "========================================================================================"
sudo apt-get update -y 
sudo apt-get upgrade -y

echo "Create Team Users and grant root privileges"
echo "========================================================================================"
sudo adduser mjc18171
sudo usermod -aG sudo mjc18171
sudo passwd --delete mjc18171
cp .keys/id_ed25519.pub /home/mjc18171/.ssh
 
sudo adduser stefk
sudo usermod -aG sudo stefk
sudo passwd --delete stefk
cp .keys/stef.pub /home/stefk/.ssh
 
sudo adduser krr74113
sudo usermod -aG sudo krr74113
sudo passwd --delete krr74113
cp .keys/kim.pub /home/krr74113/.ssh
 
sudo adduser msn60002
sudo usermod -aG sudo msn60002
sudo passwd --delete msn60002
cp .keys/martini.pub /home/msn60002/.ssh

#cp authorized keys into root
cp .keys/authorized_keys /root/.ssh
 
echo "Installing Apache2 Web server"
echo "========================================================================================"
sudo apt-get install apache2 -y
 
echo "Installing MySQL"
echo "========================================================================================"
sudo apt-get install mysql-server -y
# Enter password: COMP424
mysql -u root -p
echo "exit"

#copy apache2 config file
cp .apache2_files/apache2.conf /etc/apache2

echo "Installing PHP"
echo "========================================================================================"
#this is install will prompt you, select apache2
#another prompt will come up, select yes
sudo apt-get install phpmyadmin -y
# Select apache2
mysql -u root -p

#copy php apache2 config file
cp .php_files/php.ini /etc/php/7.4/apache2

#create an admin account to access phpmyadmin
# Select YES when prompted
echo "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'COMP424';"
echo "GRANT ALL PRIVILEGES ON * . * TO 'admin'@'localhost';"
echo "FLUSH PRIVILEGES;"
echo "exit"

sudo apt-get install php -y
#add php files to /var/www/html unless you alias/redirect to it

echo "Enabling Modules"
echo "========================================================================================"
sudo a2enmod alias
sudo a2enmod ssl
sudo a2ensite default-ssl
 
echo "Restarting Apache"
echo "========================================================================================"
sudo service apache2 restart
 
echo "Installing iptables"
echo "========================================================================================"
sudo apt-get install iptables

echo "Installing OpenSSH"
echo "========================================================================================"
sudo apt-get install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

echo "Installing wget"
echo "========================================================================================"
apt-get install wget

echo "Installing make"
echo "========================================================================================"
sudo apt-get install -y make

echo "Installing cmake"
echo "========================================================================================"
sudo apt-get -y install cmake

echo "Time to install snort!"
echo "========================================================================================"

echo "Creating Snort src dir"
echo "========================================================================================"
sudo dpkg-reconfigure tzdata
mkdir ~/snort_src
cd ~/snort_src

echo "Installing Snort Prereqs"
echo "========================================================================================"
sudo apt-get install -y build-essential autotools-dev libdumbnet-dev libluajit-5.1-dev libpcap-dev \
	zlib1g-dev pkg-config libhwloc-dev cmake liblzma-dev openssl libssl-dev cpputest libsqlite3-dev \
	libtool uuid-dev git autoconf bison flex libcmocka-dev libnetfilter-queue-dev libunwind-dev \
	libmnl-dev ethtool

echo "Installing safec for runtime bounds checks"
echo "========================================================================================"
cd ~/snort_src
wget https://github.com/rurban/safeclib/releases/download/v02092020/libsafec-02092020.tar.gz
tar -xzvf libsafec-02092020.tar.gz
cd libsafec-02092020.0-g6d921f
./configure
make
sudo make install

echo "Installing Perl Compatible Regular Expressions"
echo "========================================================================================"
cd ~/snort_src/
wget https://ftp.pcre.org/pub/pcre/pcre-8.45.tar.gz
tar -xzvf pcre-8.45.tar.gz
cd pcre-8.45
./configure
make
sudo make install

echo "Installing gperftools 2.9"
echo "========================================================================================"
cd ~/snort_src
wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.9.1/gperftools-2.9.1.tar.gz
tar xzvf gperftools-2.9.1.tar.gz
cd gperftools-2.9.1
./configure
make
sudo make install

echo "Installing Ragel"
echo "========================================================================================"
cd ~/snort_src
wget http://www.colm.net/files/ragel/ragel-6.10.tar.gz
tar -xzvf ragel-6.10.tar.gz
cd ragel-6.10
./configure
make
sudo make install

echo "Downloading Boost C++ libraries"
echo "========================================================================================"
cd ~/snort_src
wget https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.gz
tar -xvzf boost_1_76_0.tar.gz

echo "Installing Hyperscan 5.4"
echo "========================================================================================"
cd ~/snort_src
wget https://github.com/intel/hyperscan/archive/refs/tags/v5.4.0.tar.gz
tar -xvzf v5.4.0.tar.gz
mkdir ~/snort_src/hyperscan-5.4.0-build
cd hyperscan-5.4.0-build/
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBOOST_ROOT=~/snort_src/boost_1_76_0/ ../hyperscan-5.4.0
make
sudo make install

echo "Installing flatbuffers"
echo "========================================================================================"
cd ~/snort_src
wget https://github.com/google/flatbuffers/archive/refs/tags/v2.0.0.tar.gz -O flatbuffers-v2.0.0.tar.gz
tar -xzvf flatbuffers-v2.0.0.tar.gz
mkdir flatbuffers-build
cd flatbuffers-build
cmake ../flatbuffers-2.0.0
make
sudo make install

echo "Installing Data Acquisition library"
echo "========================================================================================"
cd ~/snort_src
wget https://github.com/snort3/libdaq/archive/refs/tags/v3.0.4.tar.gz -O libdaq-3.0.4.tar.gz
tar -xzvf libdaq-3.0.4.tar.gz
cd libdaq-3.0.4
./bootstrap
./configure
make
sudo make install

echo "Updating shares libraries"
echo "========================================================================================"
sudo ldconfig

echo "Installing Snort 3"
echo "========================================================================================"
cd ~/snort_src
wget https://github.com/snort3/snort3/archive/refs/tags/3.1.6.0.tar.gz -O snort3-3.1.6.0.tar.gz
tar -xzvf snort3-3.1.6.0.tar.gz
cd snort3-3.1.6.0
./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc
cd build
make
sudo make install

echo "Confirm snort version"
echo "========================================================================================"
/usr/local/bin/snort -V

echo "testing snort with the default config file"
echo "========================================================================================"
snort -c /usr/local/etc/snort/snort.lua

exit 0
