#!/bin/bash

enable_ssh () {
  systemctl enable ssh
}

setup_static_ip () {
  echo "interface wlan0
  static ip_address=192.168.0.3/24
  static routers=192.168.0.1
  static domain_name_servers=89.216.1.30
  " >> /etc/dhcpcd.conf
}

setup_wifi () {
  read -p "Enter ssid: " ssid
  read -sp "Enter password: " password
  
  echo "network={
    ssid=\"${ssid}\"
    psk=\"${password}\"
    key_mgmt=WPA-PSK
 }" >> /etc/wpa_supplicant/wpa_supplicant.conf
}

setup_samba () {
  apt-get install samba samba-common-bin

  echo "[NetworkStorage]
  path = /mnt/NetworkStorage
  available = yes
  valid users = pi
  read only = no
  browsable = yes
  public = yes
  writable = yes" >> /etc/samba/smb.conf

  echo "/dev/sda1 /mnt/NetworkStorage auto nofail,uid=pi,gid=pi,umask=002,noatime 0 0" >> /etc/fstab
  smbpassword -a pi
}

init () {

if [[ $(id -u) -ne 0 ]];
	then echo "Please run this script as root"
	exit 1
fi

read -p "Do you want to setup wifi? Y/n " useWifiSetup
if [ "$useWifiSetup" == "Y" ];
	then setup_wifi
fi

setup_static_ip
enable_ssh
setup_samba
}

init

