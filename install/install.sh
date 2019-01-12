#!/bin/bash

# FReeCP installer

#-----------------------------------------#
# Supported Operating Systems             #
#                                         #
# CentOS 7                                #
#-----------------------------------------#

#----------------VARIABLES----------------#
FREECP='/usr/local/freecp'
CPSERVER='http://foggetrof.esy.es'

#--------------VARIABLES-END--------------#

clear

#------------------CHECK------------------#
# Verify that the script is running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

# Check if the FReeCP panel is installed
if [ -d $FREECP ]; then
	echo "FReeCP panel already installed"
	exit 1
fi

# OS
case $(head -n1 /etc/issue | cut -f 1 -d ' ') in
    Debian)     type="debian" ;;
    Ubuntu)     type="ubuntu" ;;
    Amazon)     type="amazon" ;;
    *)          type="rhel" ;;
esac

#----------------CHECK-END----------------#

#---------------INSTALLATION--------------#

if [ -e '/usr/bin/wget' ]; then
    wget -O install-$type.sh $CPSERVER/install/install-$type.sh
    if [ "$?" -eq '0' ]; then
        bash install-$type.sh $*
        exit
    else
        echo "Error: install-$type.sh download failed."
        exit 1
    fi
fi

#-------------INSTALLATION-END------------#

exit 