#!/usr/bin/bash
# 
# Date: 09/08/23
# Notes: Script to authenticate the source machine to the Gonzaga active directory 
# By: Dominic Orsi 
#

# Global Variables
ADUSER="schnagl"

# Colors for bash output
GREEN='\033[0;32m'
RED='\033[0;31m'
NOCOLOR='\033[0m'

echo -e "${RED}The Active Directory user is: $ADUSER${NOCOLOR}"
sleep 1s

echo -e "${GREEN}STARTING ACTIVE DIRECTORY JOIN SCRIPT${NOCOLOR}"

sudo -n true
test $? -eq 0 || exit 1 "${RED}YOU SHOULD HAVE SUDO PRIVLEGE TO RUN THIS SCRIPT${NOCOLOR}"

# Joining AD realm
sudo realm join -v -U $ADUSER gonzaga.edu

# Changing file name from copy and then adding correct permissions
sudo mv /etc/sssd/sssd.conf.NEW /etc/sssd/sssd.conf
sudo chmod 600 /etc/sssd/sssd.conf
sudo chown root:root /etc/sssd/sssd.conf

echo -e "${GREEN}DONE WITH ACTIVE DIRECTORY JOIN!${NOCOLOR}"

echo "Do you want to reboot the machine? y/n"
read REBOOT

if [ "$REBOOT" == "y" ]; then
   echo "REBOOTING"
   sudo reboot
fi
