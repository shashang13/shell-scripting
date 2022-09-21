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


logFile=/tmp/mongodb.log
rm -f $logFile

descriptionPrint 'Setup MongoDB repos'
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
statusCheck $?


descriptionPrint 'Install MongoDB'
yum install -y mongodb-org >> $logFile

descriptionPrint 'Starting Service'
systemctl enable mongod && systemctl start mongod
statusCheck $?

descriptionPrint 'Update Mongodb config file'
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
statusCheck $?

#
##restart the service
#systemctl restart mongod
#statusCheck $?

#Every Database needs the schema to be loaded for the application to work.
#Download the schema and load it.

#descriptionPrint 'Downloading the schema'
## curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
#statusCheck $?
#
#descriptionPrint 'Extract schema'
#cd /tmp && unzip -o mongodb.zip
#
#descriptionPrint 'Load Schema'
#cd mongodb-main && mongo < catalogue.js && mongo < users.js
