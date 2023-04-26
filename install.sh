#!/bin/bash
# 
# Date: 03/06/23
# Notes: Install script for Mint Desktops. Downloads apps and then adds the machine to Active Directory. 
#        Only requires the user to enter their password for realm authentification
# By: Dominic Orsi 
#

# Global Variables
user=$SUDO_USER
path="/media/$user/LINUXFILES/"
downloadpath="/home/$user/Downloads"
machinename=$(hostname)
hostnameending=".gonzaga.edu"
aduser="schnagl"

# Colors for bash outboot
green='\033[0;32m'
red='\033[0;31m'
nocolor='\033[0m'

# Removed -e for fail on error to get chmod at the end of the script to work since errors are thrown that we do not care about
set -u pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "${red}YOU SHOULD HAVE SUDO PRIVLEGE TO RUN THIS SCRIPT${nocolor}"

echo -e "${red}THE USERNAME OF THE USER IS $user!${nocolor}"
sleep 3s

echo -e "${red}THE USERNAME FOR ACTIVE DIRECTORY AUTHENTIFICATION IS $aduser!${nocolor}"
sleep 3s 

# Checking for which path to use
if [ -e "$path" ]; then
   echo -e "${green}USING USB PATH${nocolor}"
else 
   echo -e "${green}CHANGED PATH TO PWD${nocolor}"
   PATH=$PWD
fi

echo -e "${green}STARTING INSTALL SCRIPT${nocolor}"

# Changing machine's name
if [[ ! "$machinename" == *"$hostnameending" ]]; then
   sudo hostnamectl set-hostname $machinename.gonzaga.edu
fi

# Checking to see if the no snap store preference is there, if it is, remove it
if [ -f /etc/apt/preferences.d/nosnap.pref ]; then
   echo -e "${green}Removing nosnap.pref${nocolor}"
   sudo rm /etc/apt/preferences.d/nosnap.pref
fi

# Adding PHP repo
sudo add-apt-repository ppa:ondrej/php -y

# Updating apt to reflect adding of php repo
sudo apt-get update
sudo apt upgrade -y

echo -e "${green}Installing packages${nocolor}"
while read -r p ; do sudo apt-get install -y $p ; done < <(cat << "EOF"
   g++
   nodejs
   npm
   python3-pip
   openjdk-17-jdk
   git
   sqlitebrowser
   graphviz
   apache2
   php8.0
   libapache2-mod-php8.0
   php8.0-mysql
   php-xdebug
   qemu-system-x86
   pass
   uidmap
   build-essential
   software-properties-common
   vim
   openssh-server
   valgrind
   gedit
   ocaml
   snapd
   libgl1-mesa-glx 
   libegl1-mesa 
   libxrandr2 
   libxss1 
   libxcursor1 
   libxcomposite1 
   libasound2 
   libxi6 
   libxtst6
   realmd
   sssd
   sssd-tools
   libpam-sss
   libnss-sss
   samba-common-bin
   adcli
   oddjob
   oddjob-mkhomedir
   wget
   curl
   ca-certificates
   gnupg
   lsb-release
   apt-transport-https
EOF
)
echo -e "${green}Done installing apt software${nocolor}"

# NPM installs
echo -e "${green}Starting NPM installs${nocolor}"
sudo npm install --global yarn
# React Native Enviornment Install
sudo npm install --global expo-cli
echo -e "${green}NPM installs done${nocolor}"

# Moving of files from USB to Downloads folder
echo -e "${green}Moving files from USB to Downloads folder${nocolor}"
sudo cp $path/Files/bkgrd_bulldog.jpg /usr/share/backgrounds/linuxmint/default_background.jpg
echo -e "${green}All done moving files${nocolor}"

# Installing Snap Apps
echo -e "${green}Installing Snap Apps${nocolor}"
sudo snap install flutter --classic
sudo snap install intellij-idea-community --classic --edge
sudo snap install heroku --classic
sudo snap install code --classic
sudo snap install android-studio --classic

# add the gpg key for docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# add the repository 
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo "$UBUNTU_CODENAME") stable"
# Updating apt to get docker repos
sudo apt-get update
# Installing apt packages of docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Changing Directory to Downloads for wget
cd /home/$user/Downloads
# Downloading docker desktop from web
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.17.0-amd64.deb 
# Installing docker desktop
sudo apt-get install ./docker-desktop-4.17.0-amd64.deb 
# Read and Write permissions to these files for Docker
sudo chmod 646 /etc/sub*
# Moving Docker.sh file to allow docker to by run by non-master users
sudo cp $path/Documents/docker.sh /etc/profile.d/docker.sh

# Downloading and installing gnupg 
wget https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.0.tar.bz2 -O gnupg-2.tar.bz2
sudo tar -xf gnupg-2.tar.bz2 -C /opt

# Downloading and installing conda
wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh -O anaconda.sh
sudo bash anaconda.sh -b -p /opt/anaconda3
# Replace root .bashrc with one with conda
sudo cp $path/Documents/.bashrc /root/.bashrc
sudo chmod 644 /root/.bashrc
# Reload bashrc file
source /root/.bashrcs
# update conda (package manager) and anaconda 
conda update conda
conda update anaconda

# Installing python packages
sudo pip3 install --upgrade pip
pip3 install testresources
pip3 install tabulate
pip3 install pytest
pip3 install textblob
pip3 install wordcloud
pip3 install setuptools==51.1.1
pip3 install appdirs
pip3 install textatistic
pip3 install spacy
pip3 install jupyterlab
pip3 install notebook

# Getting new updates after installing all packages
sudo apt update
sudo apt upgrade -y

# Changing lightdm.conf file to allow user login and hide user list
sudo cp $path/Documents/lightdm.conf /etc/lightdm/lightdm.conf

# Changing sudoers file
sudo cp $path/Documents/sudoers /etc/sudoers

# Allowing SSH
sudo ufw allow ssh
sudo ufw enable
sudo cp $path/Documents/sshd_config /etc/ssh/sshd_config


# Setting up desktop
sudo cp -r $path/Desktop /etc/skel/Desktop
sudo cp -r $path/Desktop /home/$user/
cd /home/$user/Desktop
sudo chown master *.desktop
sudo chmod +x gio set /home/$user/Desktop/*.desktop "metadata::trusted" true
sudo chmod +x gio set /etc/skel/Desktop/*.desktop "metadata::trusted" true

# Setting USB permissions for Adruinos
sudo cp $USBPATH/Documents/50-myusb.rules /etc/udev/rules.d
sudo chown root:root /etc/udev/rules.d

# Setting tmp file permissions for Adruinos
mkdir /tmp/arduino
sudo chmod 777 /tmp/arduino

# Removing unneeded packages
sudo apt autoremove -y

#######
# ACTIVE DIRECTORY SETUP
#######

# Disabling DNS for AD
sudo systemctl disable systemd-resolved.service
sudo systemctl stop systemd-resolved.service
sudo rm /etc/resolv.conf
sudo service network-manager restart

# Moving configuration files to their respective places
sudo cp $path/Documents/sssd.conf /etc/sssd/sssd.conf 
sudo cp $path/Documents/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
sudo cp $path/Documents/mkhomedir /usr/share/pam-configs/mkhomedir
sudo pam-auth-update --enable mkhomedir

# Updating configuration files permissions
sudo chmod 600 /etc/sssd/sssd.conf
sudo chown root:root /etc/sssd/sssd.conf
sudo chmod 700 /home/master

# Adding the machine to Active Directory
sudo realm leave gonzaga.edu -U $aduser -v
sudo realm join gonzaga.edu -U $aduser -v

# Restarting sssd to reflect AD join
sudo service sssd restart

echo -e "${green}DONE WITH INSTALL!${nocolor}"

echo "Do you want to reboot the machine? y/N"
read REBOOT

if [ "$REBOOT" == "y" ]; then
   echo "REBOOTING"
   sudo reboot
fi
