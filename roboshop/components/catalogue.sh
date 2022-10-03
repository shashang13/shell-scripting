#!/bin/bash

source components/common.sh

descriptionPrint "Performing Prereqs for Catalogue components"
echo "Download & Install nodejs" &>>${logFile}
curl -fsL https://rpm.nodesource.com/setup_lts.x | bash - &>>${logFile} && echo "" &>>${logFile} && yum install nodejs -y &>>${logFile}
statusCheck $? "${STAGE}"

id ${App_User} &>>${logFile}
if [ $? -ne 0 ]; then
  descriptionPrint "Adding Application User"
  useradd ${App_User} &>>${logFile}
  statusCheck $? "${STAGE}"
fi

descriptionPrint "Download Catalogue component"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${logFile}
statusCheck $? "${STAGE}"

descriptionPrint "Cleanup Old Content"
rm -rf /home/roboshop/catalogue &>>${logFile}
statusCheck $? "${STAGE}"

descriptionPrint "Extract and Install Catalogue Application"
cd /home/roboshop &>>${logFile} && unzip -o /tmp/catalogue.zip &>>${logFile} && mv catalogue-main catalogue &>>${logFile}
statusCheck $? "${STAGE}"

descriptionPrint "Install Application dependencies"
cd /home/roboshop/catalogue &>>${logFile} && npm install &>>${logFile}
statusCheck $? "${STAGE}"

descriptionPrint "Fix App User Permissions"
chown -R ${App_User}:${App_User} /home/roboshop/
statusCheck $? "${STAGE}"


#descriptionPrint ""
#Update SystemD file with correct IP addresses
#
#    Update `MONGO_DNSNAME` with MongoDB Server IP
#
#2. Now, lets set up the service with systemctl.
#
#```bash
## mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
## systemctl daemon-reload
## systemctl start catalogue
## systemctl enable catalogue
#
#```