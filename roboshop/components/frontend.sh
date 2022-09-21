#!/bin/bash

statusCheck (){
  if [ "$1" -eq 0 ]; then
    echo -e "\e[32m $1 is a SUCCESS\e[0m"
  else
    echo -e "\e[31m $1 is FAILURE\e[0m"
    exit "$1"
  fi
}

descriptionPrint () {
  echo -e "\n--------------------\e[36m${1}\e[0m----------------------"
}


################# Main Program ################
USER_ID=$(id -u)
if [ ${USER_ID} -ne 0 ]; then
  echo You need to be root user to execute this program
  exit 1
fi

logFile=/tmp/roboshop.log
rm -f $logFile

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
m frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>$logFile
statusCheck $?

descriptionPrint "Starting Nginx"
systemctl enable nginx >>$logFile && systemctl start nginx >>$logFile
statusCheck $?