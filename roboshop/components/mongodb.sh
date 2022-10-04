#!/bin/bash
source components/common.sh

descriptionPrint 'Setup MongoDB repos'
curl -f -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>> $logFile
statusCheck $? "${STAGE}"


descriptionPrint 'Install MongoDB'
yum install -y mongodb-org &>>${logFile}
statusCheck $? "${STAGE}"

descriptionPrint 'Update Mongodb config file'
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${logFile}
statusCheck $? "${STAGE}"

descriptionPrint 'MongoDB Schema Download'
curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>${logFile}
statusCheck $? "${STAGE}"

descriptionPrint 'Extract schema'
cd /tmp &>>${logFile} && unzip -o mongodb.zip &>>${logFile}
statusCheck $? "${STAGE}"

descriptionPrint 'Load Schema'
cd mongodb-main || exit &>>${logFile}
for schema in catalogue users
do
  echo -e "Loading ${schema} Schema"
  mongo < ${schema}.js >>${logFile}
  statusCheck $? "Loading ${schema} schema"
done

descriptionPrint 'Starting Service'
systemctl enable mongod &>>${logFile} && systemctl restart mongod &>>${logFile}
statusCheck $? "${STAGE}"
