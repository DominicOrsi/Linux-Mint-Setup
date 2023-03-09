#!/bin/sh

FILEPATH='/media/master/LINUXFILES/Documents'

set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo Changing Machine Name
MACHINENAME=$(hostname)
sudo hostnamectl set-hostname $MACHINENAME.gonzaga.edu

echo installing the needed Active Directory Authentication software
while read -r p ; do sudo apt-get install -y $p ; done < <(cat << "EOF"
    realmd
    sssd
    sssd-tools
    libpam-sss
    libnss-sss
    samba-common-bin
    adcli
    oddjob
    oddjob-mkhomedir
EOF
)

echo Disabling DNS
sudo systemctl disable systemd-resolved.service
sudo systemctl stop systemd-resolved.service
sudo rm /etc/resolv.conf
sudo service network-manager restart
echo Done with DNS

echo moving NetworkManager.conf, sssd.conf, and mkhomedir to the correct place
sudo cp $FILEPATH/sssd.conf /etc/sssd/sssd.conf 
sudo cp $FILEPATH/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
sudo cp $FILEPATH/mkhomedir /usr/share/pam-configs/mkhomedir
sudo pam-auth-update --enable mkhomedir
echo all done moving files

echo changing file permissions
sudo chmod 600 /etc/sssd/sssd.conf
sudo chown root:root /etc/sssd/sssd.conf
sudo chmod 700 /home/master
echo done chaning file permissions

echo Setting up Realm
sudo realm leave gonzaga.edu -U schnagl -v
sudo realm join gonzaga.edu -U schnagl -v
echo Done joining Realm

# Moving the file again because sometimes it does not work
sudo cp $FILEPATH/sssd.conf /etc/sssd/sssd.conf 

echo restarting sssd service
sudo service sssd restart
echo done restarting service
