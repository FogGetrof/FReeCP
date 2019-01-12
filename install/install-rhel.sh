#!/bin/bash

# FReeCP RHEL/CentOS installer

clear

#------------------CHECK------------------#
# Verify that the script is running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

#----------------CHECK-END----------------#

#---------------INSTALLATION--------------#
# Print the most beautiful ASCII logo
echo
echo '   █████▒██▀███  ▓█████ ▓█████  ▄████▄   ██▓███  '
echo ' ▓██   ▒▓██ ▒ ██▒▓█   ▀ ▓█   ▀ ▒██▀ ▀█  ▓██░  ██▒'
echo ' ▒████ ░▓██ ░▄█ ▒▒███   ▒███   ▒▓█    ▄ ▓██░ ██▓▒'
echo ' ░▓█▒  ░▒██▀▀█▄  ▒▓█  ▄ ▒▓█  ▄ ▒▓▓▄ ▄██▒▒██▄█▓▒ ▒'
echo ' ░▒█░   ░██▓ ▒██▒░▒████▒░▒████▒▒ ▓███▀ ░▒██▒ ░  ░'
echo '  ▒ ░   ░ ▒▓ ░▒▓░░░ ▒░ ░░░ ▒░ ░░ ░▒ ▒  ░▒▓▒░ ░  ░'
echo '  ░       ░▒ ░ ▒░ ░ ░  ░ ░ ░  ░  ░  ▒   ░▒ ░     '
echo '  ░ ░     ░░   ░    ░      ░   ░        ░░       '
echo '           ░        ░  ░   ░  ░░ ░               '
echo '                               ░                 '
echo -e "\n"

# Installation WGET
echo -en "Installation - wget... "
yum -y install wget &> /dev/null
if [ $? -eq 0 ]; then
    echo -en "\033[1;32m [OK] \033[0m\n"
else
    echo -e "\033[1;31m An error occurred while installing! [ERROR] \033[0m\n"
    exit
fi

# System Update
echo -en "System Update... "
yum -y update &> /dev/null
if [ $? -eq 0 ]; then
    echo -en "\033[1;32m [OK] \033[0m\n"
else
    echo -e "\033[1;31m An error occurred while updating! [ERROR] \033[0m\n"
    exit
fi

# Installation Apache
echo -en "Installation - Apache... "
yum -y install httpd &> /dev/null
if [ $? -eq 0 ]; then
    echo -en "\033[1;32m [OK] \033[0m\n"
else
    echo -e "\033[1;31m An error occurred while installing! [ERROR] \033[0m\n"
    exit
fi

# Adding Apache to Startup
echo -en "Adding Apache to Startup... "
systemctl start httpd &> /dev/null
systemctl enable httpd &> /dev/null
if [ $? -eq 0 ]; then
    echo -en "\033[1;32m [OK] \033[0m\n"
else
    echo -e "\033[1;31m An error occurred while adding Apache to startup! [ERROR] \033[0m\n"
    exit
fi

# Creating the Apache virtual host configuration file
echo -en "Creating the Apache virtual host configuration file... "
sudo mkdir /etc/httpd/sites-enabled &> /dev/null
sudo mkdir /etc/httpd/sites-available &> /dev/null
sudo touch /etc/httpd/sites-available/$HOSTNAME.conf &> /dev/null
sudo echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
sudo echo "Listen 8000" >> /etc/httpd/conf/httpd.conf
sudo echo "<VirtualHost *:8000>" >> /etc/httpd/sites-available/$HOSTNAME.conf
sudo echo "ServerName "$HOSTNAME >> /etc/httpd/sites-available/$HOSTNAME.conf
sudo echo "ServerAdmin root@localhost" >> /etc/httpd/sites-available/$HOSTNAME.conf
sudo echo 'DocumentRoot "/usr/local/freecp"' >> /etc/httpd/sites-available/$HOSTNAME.conf
sudo echo "</VirtualHost>" >> /etc/httpd/sites-available/$HOSTNAME.conf
sudo ln -s /etc/httpd/sites-available/$HOSTNAME.conf /etc/httpd/sites-enabled/$HOSTNAME.conf
if [ $? -eq 0 ]; then
    echo -en "\033[1;32m [OK] \033[0m\n"
else
    echo -e "\033[1;31m An error occurred while creating! [ERROR] \033[0m\n"
    exit
fi

# Deactivating SELinux
sudo setenforce 0

# Reload Apache
echo -en "Reload Apache... "
sudo service httpd restart &> /dev/null
if [ $? -eq 0 ]; then
    echo -en "\033[1;32m [OK] \033[0m\n"
else
    echo -e "\033[1;31m An error occured while rebooting! [ERROR] \033[0m\n"
    exit
fi

# Installation Firewall
#echo -en "Installation - Firewall... "
#yum -y install firewalld &> /dev/null
#if [ $? -eq 0 ]; then
#    echo -en "\033[1;32m [OK] \033[0m\n"
#else
#    echo -e "\033[1;31m An error occurred while installing! [ERROR] \033[0m\n"
#    exit
#fi

# Adding Firewall to Startup
#echo -en "Adding Firewall to Startup... "
#systemctl start firewalld &> /dev/null
#systemctl enable firewalld &> /dev/null
#if [ $? -eq 0 ]; then
#    echo -en "\033[1;32m [OK] \033[0m\n"
#else
#    echo -e "\033[1;31m An error occurred while adding Firewall to startup! [ERROR] \033[0m\n"
#    exit
#fi

# Add permissions to the firewall
#echo -en "Add permissions to the firewall... "
#firewall-cmd --permanent --zone=public --add-service=http &> /dev/null
#firewall-cmd --permanent --zone=public --add-service=https &> /dev/null
#firewall-cmd --reload &> /dev/null
#if [ $? -eq 0 ]; then
#    echo -en "\033[1;32m [OK] \033[0m\n"
#else
#    echo -e "\033[1;31m An error occurred while adding permissions to the firewall! [ERROR] \033[0m\n"
#    exit
#fi

# Installation MySQL
echo -en "Installation - MySQL... "
yum -y install mariadb-server mariadb &> /dev/null
if [ $? -eq 0 ]; then
    echo -en "\033[1;32m [OK] \033[0m\n"
else
    echo -e "\033[1;31m An error occurred while installing! [ERROR] \033[0m\n"
    exit
fi

# Adding MySQL to Startup
echo -en "Adding MySQL to Startup... "
systemctl start mariadb &> /dev/null
systemctl enable mariadb &> /dev/null
if [ $? -eq 0 ]; then
    echo -en "\033[1;32m [OK] \033[0m\n"
else
    echo -e "\033[1;31m An error occurred while adding MySQL to startup! [ERROR] \033[0m\n"
    exit
fi

# Installation PHP
echo -en "Installation - PHP... "
yum -y install php php-mysql &> /dev/null
if [ $? -eq 0 ]; then
    echo -en "\033[1;32m [OK] \033[0m\n"
else
    echo -e "\033[1;31m An error occurred while installing! [ERROR] \033[0m\n"
    exit
fi

# Reload Apache
echo -en "Reload Apache... "
systemctl restart httpd &> /dev/null
if [ $? -eq 0 ]; then
    echo -en "\033[1;32m [OK] \033[0m\n"
else
    echo -e "\033[1;31m An error occured while rebooting! [ERROR] \033[0m\n"
    exit
fi

# Initializing EPEL Repository
echo -en "Initializing EPEL Repository... "
yum -y install epel-release &> /dev/null
if [ $? -eq 0 ]; then
    echo -en "\033[1;32m [OK] \033[0m\n"
else
    echo -e "\033[1;31m An error occurred while initializing the EPEL repository! [ERROR] \033[0m\n"
    exit
fi

# Installation phpMyAdmin
echo -en "Installation - phpMyAdmin... "
yum -y install phpmyadmin &> /dev/null
if [ $? -eq 0 ]; then
    echo -en "\033[1;32m [OK] \033[0m\n"
else
    echo -e "\033[1;31m An error occurred while installing! [ERROR] \033[0m\n"
    exit
fi

# Reload Apache
echo -en "Reload Apache... "
systemctl restart httpd &> /dev/null
if [ $? -eq 0 ]; then
    echo -en "\033[1;32m [OK] \033[0m\n"
else
    echo -e "\033[1;31m An error occured while rebooting! [ERROR] \033[0m\n"
    exit
fi

# Creating FReeCP panel files
sudo mkdir /usr/local/freecp/
sudo wget -O /usr/local/freecp/index.php http://foggetrof.esy.es/freecp/index.php &> /dev/null
sudo chown apache:apache -R /usr/local/freecp/
if [ $? -eq 0 ]; then
    echo -e "Creating FReeCP panel files... \033[1;32m [OK] \033[0m\n"
else
    echo -e "\033[1;31m An error occurred while creating FReeCP panel files! [ERROR] \033[0m\n"
    exit
fi

sleep 2
#-------------INSTALLATION-END------------#

#---------------SUCCESSFULLY--------------#
# Successful installation
clear
echo
echo '   █████▒██▀███  ▓█████ ▓█████  ▄████▄   ██▓███  '
echo ' ▓██   ▒▓██ ▒ ██▒▓█   ▀ ▓█   ▀ ▒██▀ ▀█  ▓██░  ██▒'
echo ' ▒████ ░▓██ ░▄█ ▒▒███   ▒███   ▒▓█    ▄ ▓██░ ██▓▒'
echo ' ░▓█▒  ░▒██▀▀█▄  ▒▓█  ▄ ▒▓█  ▄ ▒▓▓▄ ▄██▒▒██▄█▓▒ ▒'
echo ' ░▒█░   ░██▓ ▒██▒░▒████▒░▒████▒▒ ▓███▀ ░▒██▒ ░  ░'
echo '  ▒ ░   ░ ▒▓ ░▒▓░░░ ▒░ ░░░ ▒░ ░░ ░▒ ▒  ░▒▓▒░ ░  ░'
echo '  ░       ░▒ ░ ▒░ ░ ░  ░ ░ ░  ░  ░  ▒   ░▒ ░     '
echo '  ░ ░     ░░   ░    ░      ░   ░        ░░       '
echo '           ░        ░  ░   ░  ░░ ░               '
echo '                               ░                 '
echo -e "\n"


echo 'Congratulations on the successful installation of FReeCP!'
echo
echo 'The panel is available by url: http://'$HOSTNAME':8000'
echo
echo 'We hope that you like FReeCP'
echo 'Thank you.'
echo
echo 'freecp.pw team'

#-------------SUCCESSFULLY-END------------#

exit