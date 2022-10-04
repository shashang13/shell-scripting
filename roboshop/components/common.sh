statusCheck (){
  if [ "$1" -eq 0 ]; then
    echo -e "\e[32m $2 is a SUCCESS\e[0m" |tee -a ${logFile}
  else
    echo -e "\e[31m $2 is FAILURE\e[0m" |tee -a ${logFile}
    exit "$1"
  fi
}

descriptionPrint () {
  STAGE="${1}"
  echo -e "\n--------------------\e[36m${1}\e[0m----------------------" |tee -a ${logFile}
}

App_User=roboshop

logFile=/tmp/roboshop.log
rm -f $logFile

nodeJS () {
  descriptionPrint "Performing Prereqs for ${COMPONENT} components"
  echo "Download & Install nodejs" &>>${logFile}
  curl -fsL https://rpm.nodesource.com/setup_lts.x | bash - &>>${logFile} && echo "" &>>${logFile} && yum install nodejs -y &>>${logFile}
  statusCheck $? "${STAGE}"

  id ${App_User} &>>${logFile}
  if [ $? -ne 0 ]; then
    descriptionPrint "Adding Application User"
    useradd ${App_User} &>>${logFile}
    statusCheck $? "${STAGE}"
  fi

  descriptionPrint "Download ${COMPONENT} component"
  curl -f -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${logFile}
  statusCheck $? "${STAGE}"

  descriptionPrint "Cleanup Old Content"
  rm -rf /home/roboshop/${COMPONENT} &>>${logFile}
  statusCheck $? "${STAGE}"

  descriptionPrint "Extract and Install ${COMPONENT} Application"
  cd /home/roboshop &>>${logFile} && unzip -o /tmp/${COMPONENT}.zip &>>${logFile} && mv ${COMPONENT}-main ${COMPONENT} &>>${logFile}
  statusCheck $? "${STAGE}"

  descriptionPrint "Install Application dependencies"
  cd /home/roboshop/${COMPONENT} &>>${logFile} && npm install &>>${logFile}
  statusCheck $? "${STAGE}"

  descriptionPrint "Fix App User Permissions"
  chown -R ${App_User}:${App_User} /home/roboshop/ &>>${logFile}
  statusCheck $? "${STAGE}"

  descriptionPrint "Setup SystemD file"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>${logFile} && mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${logFile}
  statusCheck $? "${STAGE}"

  descriptionPrint "Starting ${COMPONENT} Service"
  systemctl daemon-reload &>>${logFile} && systemctl restart ${COMPONENT} &>>${logFile} && systemctl enable ${COMPONENT} &>>${logFile}
  statusCheck $? "${STAGE}"
}