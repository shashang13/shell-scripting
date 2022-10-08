#!/bin/bash
source components/common.sh

descriptionPrint "Download RabbitMQ dependencies"
curl -f -L -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${logFile} && curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${logFile}
statusCheck $?

descriptionPrint "Install Erlang and RabbitMQ"
yum install erlang rabbitmq-server -y &>>${logFile}
statusCheck $?

#descriptionPrint "Install RabbitMQ"
#yum install rabbitmq-server -y
#statusCheck $?



