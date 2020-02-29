#!/bin/bash

enable_ssh () {
  systemctl enable ssh
}

setup_static_ip () {
  echo 'interface wlan0
  static ip_address=192.168.0.3/24
  static routers=192.168.0.1
  static domain_name_servers=89.216.1.30
  ' >> /etc/dhcpcd.conf
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

init () {

if [[ $(id -u) -ne 0 ]];
	then echo "Please run this script as root!"
	exit 1
fi

read -p "Do you want to setup wifi? Y/n " useWifiSetup
if [ "$useWifiSetup" == "Y" ];
	then setup_wifi
fi

setup_static_ip
enable_ssh
}

init

