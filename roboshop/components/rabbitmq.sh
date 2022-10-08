#!/bin/bash
source components/common.sh

descriptionPrint "Download RabbitMQ dependencies"
curl -f -s -L https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${logFile}
statusCheck $?

descriptionPrint "Install Erlang and RabbitMQ"
yum --skip-broken install https://github.com/rabbitmq/erlang-rpm/releases/download/v25.1/erlang-25.1-1.el8.x86_64.rpm rabbitmq-server -y &>>${logFile}
statusCheck $?

#descriptionPrint "Install RabbitMQ"
#yum install rabbitmq-server -y
#statusCheck $?



