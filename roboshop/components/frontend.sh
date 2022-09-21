#!/bin/bash

USER_ID=$(id -u)
if [ ${USER_ID} -ne 0 ]; then
  echo You need to be root user to execute this program
  exit 1
fi

statusCheck (){
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 2
  fi
}

descriptionPrint () {
  echo -e "\n--------------------\e[36m${1}\e[0m----------------------"
}

descriptionPrint 'Installing NGINX'
yum install nginx -y
statusCheck

descriptionPrint 'Downloading Frontend Software'
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
statusCheck

descriptionPrint 'Cleanup Old Nginx Content'
rm -rf /usr/share/nginx/html/*
statusCheck

descriptionPrint 'Extracting Archive'
unzip /tmp/frontend.zip
mv frontend-main/static/* .
m frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
statusCheck

descriptionPrint "Starting Nginx"
systemctl enable nginx
systemctl start nginx
statusCheck