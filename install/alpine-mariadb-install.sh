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
$STD sed -i 's/^port/#port/g' /etc/my.cnf
$STD sed -i 's/^port/#port/g' /etc/my.cnf.d/mariadb-server.cnf
$STD sed -i 's/^skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf
$STD sed -i '/\[mysqld\]/a\port=3306' /etc/my.cnf.d/mariadb-server.cnf
$STD sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf
$STD echo '#!/bin/bash' > /root/mariadb-root
$STD echo -e "\necho -e \"\nMariaDB ------------------------------------------------------------------------------------------------\"\nmariadb --version\necho -e \"--------------------------------------------------------------------------------------------------------\n\"\n\nmariadb -uroot -p$DB_PASS mysql" >> /root/mariadb-root
$STD chmod 777 /root/mariadb-root
$STD rc-service mariadb start
$STD rc-update add mariadb default

mariadb -uroot -p"$DB_PASS" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$DB_PASS' WITH GRANT OPTION;
 DELETE FROM mysql.user WHERE User='';
 DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
 DROP DATABASE test; DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
 CREATE USER 'root'@'%' IDENTIFIED BY '$DB_PASS';
 GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
 FLUSH PRIVILEGES;
 SELECT User, Host FROM mysql.user"

echo -e "\n${DGN}🗝\t MariaDB Password: \t\t${GN}root${CL} => ${GN}$DB_PASS${CL}"
ipaddr=$(/sbin/ip -4 -o addr show | awk '/inet / {print $4}' | cut -d/ -f1 | grep -v '127.0.0.1')
echo -e "${DGN}🖧\t IP Address: ${GN}\t\t\t$ipaddr${CL}\n"
msg_ok "Installed mariadb"

motd_ssh
customize
