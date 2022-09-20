#!/bin/bash

#USER_ID=$(id -u)
#if [ ${USER_ID} -ne 0 ]; then
#  echo You need to be root user to execute this program
#fi

echo "Installing NGINX"
yum install nginx -y

echo "Downloading Frontend software"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

echo "Cleanup Old Nginx Content"
cd /usr/share/nginx/html
rm -rf *

echo "Extracting Archive"
unzip /tmp/frontend.zip
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

echo "Starting Nginx"
systemctl enable nginx
systemctl start nginx