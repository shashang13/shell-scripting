#!/bin/bash
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

echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" > /tmp/rootpass.sql
DEFAULT_ROOT_PASSWD=$(grep 'temporary password' /var/log/mysqld.log|awk '{print $NF}')
mysql -uroot -p"${DEFAULT_ROOT_PASSWD}" </tmp/rootpass.sql
echo 'show databases'|mysql -uroot -p'RoboShop@1' &>>${logFile}
#
#if [ $? -ne 0 ]; then
#  descriptionPrint "Change Default Root Password"
#  mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASSWD}" </tmp/rootpass.sql &>>${logFile}
#  statusCheck $?
#fi
#
#echo 'show plugins'|mysql -uroot -p'RoboShop@1' 2>>${logFile} | grep validate_password ${logFile}
#if [ $? -eq 0 ]; then
#  descriptionPrint "Uninstall Validate plugin"
#  echo 'uninstall plugin validate_password;' > /tmp/plugin.sql
#  mysql -uroot -p'RoboShop@1' </tmp/plugin.sql &>>${logFIle}
#  statusCheck $?
#fi
### **Setup Needed for Application.**
#
#As per the architecture diagram, MySQL is needed by
#
#- Shipping Service
#
#So we need to load that schema into the database, So those applications will detect them and run accordingly.
#
#To download schema, Use the following command
#
#```bash
## curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#```
#
#Load the schema for Services.