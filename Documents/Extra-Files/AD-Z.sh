#! /bin/sh

FILEPATH='/media/master/LINUXFILES/Documents'

sudo realm join gonzaga.edu -U schnagl -v
echo Done joining Realm

# Moving the file again because sometimes it does not work
sudo cp $FILEPATH/sssd.conf /etc/sssd/sssd.conf 

echo restarting sssd service
sudo service sssd restart
echo done restarting service

sudo rm /home/master/Desktop/AD-Setup.sh
sudo rm /home/master/Desktop/AD-Z.sh
