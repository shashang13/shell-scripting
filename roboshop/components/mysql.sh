#!/bin/bash
set -x
source components/common.sh

descriptionPrint "MySQL Repo Setup"
curl -f -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${logFile}
statusCheck $?

descriptionPrint "Installing MySQL"
yum install mysql-community-server -y &>>${logFile}
statusCheck $?

descriptionPrint "Start MySQL"
systemctl enable mysqld &>>${logFile} && systemctl start mysqld &>>${logFile}
statusCheck $?

echo 'show databases'|mysql -uroot -p'RoboShop@1' &>>${logFile}
if [ $? -ne 0 ]; then
  descriptionPrint "Change Default Root Password"
  echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" > /tmp/rootpass.sql
  DEFAULT_ROOT_PASSWD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
  mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASSWD}" </tmp/rootpass.sql &>>${logFile}
  statusCheck $?
fi

echo 'show plugins'|mysql -uroot -p'RoboShop@1' 2>>${logFile} | grep validate_password &>>${logFile}
if [ $? -eq 0 ]; then
  descriptionPrint "Uninstall Validate plugin"
  echo 'uninstall plugin validate_password;' > /tmp/plugin.sql
  mysql -uroot -pRoboShop@1 </tmp/plugin.sql
  statusCheck $?
fi

descriptionPrint "Download Shipping Schemas"
curl -f -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>${logFile}
statusCheck $?

descriptionPrint "Download Shipping Schemas"
cd /tmp && unzip mysql.zip &>>${logFile}
statusCheck $?

descriptionPrint "Load Shipping Schemas"
cd mysql-main && mysql -u root -pRoboShop@1 <shipping.sql &>>${logFile}
statusCheck $?