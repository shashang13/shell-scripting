#!/bin/bash

source components/common.sh

descriptionPrint 'NGINX Installation'
yum install nginx -y  &>> $logFile
statusCheck $? "${STAGE}"

descriptionPrint 'Download Frontend'
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> $logFile
statusCheck $? "${STAGE}"

descriptionPrint 'Cleanup Old Nginx'
cd /usr/share/nginx/html/ &>>$logFile && rm -rf /usr/share/nginx/html/* &>>$logFile
statusCheck $? "${STAGE}"

descriptionPrint 'Extract Archive'
unzip -o /tmp/frontend.zip &>>$logFile && mv frontend-main/static/* . &>>$logFile
statusCheck $? "${STAGE}"

descriptionPrint 'Configure Roboshop'
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$logFile
statusCheck $? "${STAGE}"

descriptionPrint "Start Nginx"
systemctl enable nginx &>>$logFile && systemctl restart nginx &>>$logFile
statusCheck $? "${STAGE}"