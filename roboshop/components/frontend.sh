#!/bin/bash

source components/common.sh

descriptionPrint 'Installing NGINX'
yum install nginx -y  &>> $logFile
statusCheck $? "${STAGE}"

descriptionPrint 'Downloading Frontend Software'
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> $logFile
statusCheck $? "${STAGE}"

descriptionPrint 'Cleanup Old Nginx Content'
cd /usr/share/nginx/html/ &>>$logFile && rm -rf /usr/share/nginx/html/* &>>$logFile
statusCheck $? "${STAGE}"

descriptionPrint 'Extracting Archive'
unzip -o /tmp/frontend.zip &>>$logFile && mv frontend-main/static/* . &>>$logFile
statusCheck $? "${STAGE}"

descriptionPrint 'Update Roboshop Configuration'
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$logFile
statusCheck $? "${STAGE}"

descriptionPrint "Starting Nginx"
systemctl enable nginx &>>$logFile && systemctl start nginx &>>$logFile
statusCheck $? "${STAGE}"