#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE
source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"

color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apk add newt
$STD apk add curl
$STD apk add openssh
$STD apk add tzdata
$STD apk add nano
$STD apk add mc
msg_ok "Installed Dependencies"

msg_info "Installing mariadb"
$STD apk add mariadb mariadb-client mariadb-server-utils
$STD mysql_install_db --user=mysql --datadir=/var/lib/mysql
sed -i 's/^# *\(port *=.*\)/\1/' /etc/mysql/my.cnf
sed -i 's/^bind-address/#bind-address/g' /etc/mysql/mariadb.conf.d/50-server.cnf
$STD rc-service mariadb start
$STD rc-update add mariadb default
msg_info "MySQL Password: $DB_PASS"

mariadb -uroot -p"$DB_PASS" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$DB_PASS' WITH GRANT OPTION;
 DELETE FROM mysql.user WHERE User='';
 DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
 DROP DATABASE test; DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
 CREATE USER 'root'@'%' IDENTIFIED BY '$DB_PASS';
 GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
 FLUSH PRIVILEGES;
 SELECT User, Host FROM mysql.user"

msg_ok "Installed mariadb"

motd_ssh
customize
