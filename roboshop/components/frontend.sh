#!/bin/bash

#USER_ID=$(id -u)
#if [ ${USER_ID} -ne 0 ]; then
#  echo You need to be root user to execute this program
#fi

echo -e "\e[31mInstalling NGINX\e[0m"
yum install nginx -y

echo -e "\e[31mDownloading Frontend software\e[0m"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

echo -e "\e[31mCleanup Old Nginx Content\e[0m"
cd /usr/share/nginx/html
rm -rf *

echo -e "\e[31mExtracting Archive\e[0m"
unzip /tmp/frontend.zip
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[31mStarting Nginx\e[0m"
systemctl enable nginx
systemctl start nginx