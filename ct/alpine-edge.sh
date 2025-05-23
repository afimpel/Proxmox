#!/usr/bin/env bash
source <(curl -H 'Pragma: no-cache' -s https://raw.githubusercontent.com/afimpel/Proxmox/master/misc/build-afimpel.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    ___    __      _          
   /   |  / /___  (_)___  ___ 
  / /| | / / __ \/ / __ \/ _ \
 / ___ |/ / /_/ / / / / /  __/
/_/  |_/_/ .___/_/_/ /_/\___/ 
        /_/                   
Edge
EOF
}
header_info
echo -e "Loading..."
APP="Alpine-Edge"
var_install="alpine"
var_disk="8"
var_cpu="1"
var_ram="2048"
var_os="alpine"
var_version="3.21"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="0"
  PW="-password alpine"
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="yes"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="yes"
  VERB="yes"
  echo_default
}

function update_script() {
UPD=$(whiptail --backtitle "Proxmox VE Helper Scripts by afimpel" --title "SUPPORT" --radiolist --cancel-button Exit-Script "Spacebar = Select" 11 58 1 \
  "1" "Check for Alpine Updates" ON \
  3>&1 1>&2 2>&3)

header_info
if [ "$UPD" == "1" ]; then
apk update && apk upgrade
exit;
fi
}

start
build_container
description

msg_ok "Completed Successfully!\n"
