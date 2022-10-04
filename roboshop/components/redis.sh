#!/bin/bash

source components/common.sh

#Install Redis**
#
## curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
## yum install redis-6.2.7 -y

#2. Update the `bind` from`127.0.0.1`to`0.0.0.0`in config file`/etc/redis.conf`&`/etc/redis/redis.conf`

#3. Start Redis Database
## systemctl enable redis
## systemctl start redis

descriptionPrint "Download Redis repo"
curl -f -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${logFile}
statusCheck $? "${STAGE}"

descriptionPrint "Installing Redis"
yum install redis-6.2.7 -y &>>${logFile}
statusCheck $? "${STAGE}"

descriptionPrint "Update Redis Config files"
if  [ -f /etc/redis.conf ]; then
    cp /etc/redis.conf /etc/redis.conf.bk &>>${logFile} && sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>${logFile}
fi

if [ -f /etc/redis/redis.conf ]; then
  cp /etc/redis/redis.conf /etc/redis/redis.conf.bk &>>${logFile} && sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>>${logFile}
fi
statusCheck $? "${STAGE}"

descriptionPrint "Starting Redis DB"
systemctl enable redis &>>${logFile} && systemctl start redis &>>${logFile}
statusCheck $? "${STAGE}"


