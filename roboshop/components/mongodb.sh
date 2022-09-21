#!/bin/bash
source components/common.sh

descriptionPrint 'Setup MongoDB repos'
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>> $logFile
statusCheck $?


descriptionPrint 'Install MongoDB'
yum install -y mongodb-org &>> $logFile

descriptionPrint 'Update Mongodb config file'
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $logFile
statusCheck $?

descriptionPrint 'Starting Service'
systemctl enable mongod &>> $logFile && systemctl restart mongod &>>$logFile
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
