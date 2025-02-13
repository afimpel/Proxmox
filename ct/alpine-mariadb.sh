#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/afimpel/Proxmox/master/misc/build-afimpel.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/afimpel/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    __  ___           _       ____  ____ 
   /  |/  /___ ______(_)___ _/ __ \/ __ )
  / /|_/ / __  / ___/ / __  / / / / __  |
 / /  / / /_/ / /  / / /_/ / /_/ / /_/ / 
/_/  /_/\__,_/_/  /_/\__,_/_____/_____/  
Alpine
EOF
}
header_info
echo -e "Loading..."
APP="Alpine-Edge-MariaDB"
var_install="alpine-mariadb"
var_disk="16"
var_cpu="1"
var_ram="1024"
var_os="alpine"
var_version="3.21"

variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW="-password mariadb"
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
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

start
build_container
description

msg_ok "Completed Successfully!\n"
