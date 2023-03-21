# Deploying and Setting Up Linux Mint

Created: May 10, 2022 9:26 AM

Last Edited Time: March 21, 2023 3:08 PM

# Table of Contents
- [Deploying and Setting Up Linux Mint](#deploying-and-setting-up-linux-mint)
- [Table of Contents](#table-of-contents)
- [Installing Mint](#installing-mint)
  - [Setup](#setup)
  - [Booting into Mint from USB](#booting-into-mint-from-usb)
  - [Installing Mint Settings](#installing-mint-settings)
- [Installing Software](#installing-software)
  - [USB](#usb)
  - [Git](#git)
  - [Install.sh](#installsh)
    - [Testing Connection to AD](#testing-connection-to-ad)

# Installing Mint

The mint version used for the desktops in the lap are [Cinnamon 20.3 “Una” Edge](https://www.linuxmint.com/edition.php?id=296). The Edge version is required because of how new the hardware we are using is. It has the most update to date drivers for us. Any newer version of Mint will also work with this script.

## Setup

If the box you are working on is brand new, secure boot will be enabled in the bios. Boot into the bios and disable it.

## Booting into Mint from USB

To boot into mint from the USB press the `F12` key on boot to boot into the drive selections and select the USB disk with Mint on it.

## Installing Mint Settings

Start the install of Mint from the USB by selecting the first Linux Mint option on the boot screen, not compatibility mode.

Next install `mulitmedia codecs` but do not enable secure boot under it.

Choose the `Erase Disk and install Linux Mint` option for install type

Then set the correct time zone, `Los Angeles PST` .

For your name enter: `Master`

Computer Name: BC003-<ID TAG NUMBER>, i.e. `BC003-33828`

For username enter: `master`

Password is the standard password

You should be done configuring the install settings and Mint will know install itself.

# Installing Software

There are two ways you can install the software on to Mint.

1. [Using a USB stick with the install script and required files on it](#usb)
2. [Downloading the repo through git](#git)

## USB

The USB approach is simply plugging the USB stick into the box, dragging `install.sh` on to the desktop then running it with the command: `sudo bash install.sh`

## Git

The Git approach requires the user to first install git on the machine: `sudo apt install git` After installing git simply navigate to where you want to clone the repo. It can be cloned with the command: `git clone https://github.com/DominicOrsi/Linux-Mint-Setup.git` Then cd into the directory to make it the PWD. Now you can finally run the script with `sudo bash install.sh`

## Install.sh

This shell file is the main file you need to run in order to install all the needed software on to the machine. It is run with the command `sudo bash install` The script must be run with root access in order to function properly. If run without root access it will display a warning message and exit out.

### Testing Connection to AD

To test the connection to AD to make sure the computer is connected type in `id <username>`. With username being a Gonzaga account. It will take a minute to pull up the groups the account is in on AD. Another way I found to test the connection that worked was to do the ID command but as the computer is looking up the groups for the user, to sign out then try and login with a Gonzaga account.