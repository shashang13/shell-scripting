#!/bin/bash
source components/common.sh

descriptionPrint "Download RabbitMQ dependencies"
curl -f -L -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${logFile} && curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${logFile}
statusCheck $?

descriptionPrint "Install Erlang and RabbitMQ"
yum install erlang rabbitmq-server -y &>>${logFile}
statusCheck $?

descriptionPrint "Start Rabbitmq"
systemctl enable rabbitmq-server &>>${logFile} && systemctl restart rabbitmq-server &>>${logFile}
statusCheck $?

descriptionPrint "Create App User"
if [ -z "$(rabbitmqctl list_users|grep roboshop)" ]; then
  set -x
  rabbitmqctl add_user roboshop roboshop123 &>>${logFile} && rabbitmqctl set_user_tags roboshop administrator &>>${logFile} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${logFile}
  statusCheck $?
elif [ -n "$(rabbitmqctl list_users|grep roboshop)" ]; then
  echo app user already available.
fi


