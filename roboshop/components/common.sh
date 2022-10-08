statusCheck (){
if [ "$1" -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m" |tee -a ${logFile}
else
  echo -e "\e[31mFAILURE\e[0m" |tee -a ${logFile}
  exit "$1"
fi
}

descriptionPrint () {
  echo -e "\n-------------------- \e[36m${1}\e[0m ----------------------" |tee -a ${logFile}
}

logFile=/tmp/roboshop.log
rm -f $logFile

App_User=roboshop
appSetup () {
  id ${App_User} &>>${logFile}
  if [ $? -ne 0 ]; then
    descriptionPrint "Adding Application User"
    useradd ${App_User} &>>${logFile}
    statusCheck $?
  fi

  descriptionPrint "Download ${COMPONENT} component"
  curl -f -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${logFile}
  statusCheck $?

  descriptionPrint "Cleanup Old Content"
  rm -rf /home/roboshop/${COMPONENT} &>>${logFile}
  statusCheck $?

  descriptionPrint "Extract ${COMPONENT} Application"
  cd /home/roboshop &>>${logFile} && unzip -o /tmp/${COMPONENT}.zip &>>${logFile} && mv ${COMPONENT}-main ${COMPONENT} &>>${logFile}
  statusCheck $?
}

serviceSetup () {
  descriptionPrint "Fix App User Permissions"
  chown -R ${App_User}:${App_User} /home/roboshop/ &>>${logFile}
  statusCheck $?

  descriptionPrint "Setup SystemD file"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' \
         -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' \
         -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' \
         -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' \
         -e 's/CARTENDPOINT/cart.roboshop.internal/' \
         -e 's/DBHOST/mysql.roboshop.internal/' \
         -e 's/CARTHOST/cart.roboshop.internal/' \
         -e 's/USERHOST/user.roboshop.internal/' \
         -e 's/AMQPHOST/rabbitmq.roboshop.internal/' \
         -e 's/RABBITMQ-IP/rabbitmq.roboshop.internal/' \
         /home/roboshop/${COMPONENT}/systemd.service &>>${logFile} && mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${logFile}
  statusCheck $?

  descriptionPrint "Starting ${COMPONENT} Service"
  systemctl daemon-reload &>>${logFile} && systemctl restart ${COMPONENT} &>>${logFile} && systemctl enable ${COMPONENT} &>>${logFile}
  statusCheck $?
}

nodeJS () {
  descriptionPrint "Performing Prereqs for ${COMPONENT} components"
  echo "Download & Install nodejs" &>>${logFile}
  curl -fsL https://rpm.nodesource.com/setup_lts.x | bash - &>>${logFile} && echo "" &>>${logFile} && yum install nodejs -y &>>${logFile}
  statusCheck $?

  appSetup

  descriptionPrint "Install Application dependencies"
  cd /home/roboshop/${COMPONENT} &>>${logFile} && npm install &>>${logFile}
  statusCheck $?

  serviceSetup
}

maven () {
  descriptionPrint "Install Maven"
  yum install maven -y &>>${logFile}
  statusCheck $?

  appSetup

  descriptionPrint "Maven Package Managing"
  cd /home/${App_User}/${COMPONENT} &>>${logFile} && mvn clean package &>>${logFile} && mv target/shipping-1.0.jar shipping.jar &>>${logFile}
  statusCheck $?

  serviceSetup
}

payment () {
  descriptionPrint "Install Python"
  yum install python36 gcc python3-devel -y &>>${logFile}
  statusCheck $?

  appSetup

  descriptionPrint "Python Package Managing"
  pip3 install -r requirements.txt &>>${logFile}
  statusCheck $?

  serviceSetup
}

dispatch () {
  descriptionPrint "Install GoLang"
  yum install golang -y &>>${logFile}
  statusCheck $?

  appSetup

  descriptionPrint "Dispatch Package Management"
  cd ~roboshop/dispatch &>>${logFile} && go mod init dispatch &>>${logFile} && go get &>>${logFile} && go build &>>${logFile}
  statusCheck $?

  serviceSetup
}