#!/bin/bash

descriptionPrint 'Installing NGINX'
yum install nginx -y  >> $logFile
statusCheck $?

descriptionPrint 'Downloading Frontend Software'
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
statusCheck $?

descriptionPrint 'Cleanup Old Nginx Content'
cd /usr/share/nginx/html/ >>$logFile && rm -rf /usr/share/nginx/html/* >>$logFile
statusCheck $?

descriptionPrint 'Extracting Archive'
unzip -o /tmp/frontend.zip >>$logFile && mv frontend-main/static/* . >>$logFile
statusCheck $?

descriptionPrint 'Update Roboshop Configuration'
m frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$logFile
statusCheck $?

descriptionPrint "Starting Nginx"
systemctl enable nginx >>$logFile && systemctl start nginx >>$logFile
statusCheck $?