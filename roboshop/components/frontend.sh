#!/bin/bash

USER_ID=$(id -u)
if [ ${USER_ID} -ne 0 ]; then
  echo You need to be root user to execute this program
  exit 1
fi

statusCheck (){
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 2
  fi
}

descriptionPrint () {
  echo -e "\n--------------------\e[36m${1}\e[0m----------------------"
}

descriptionPrint 'Installing NGINX'
yum install nginx -y
STATUS_CHECK

echo ''
echo -e "\e[36mDownloading Frontend software\e[0m"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
STATUS_CHECK

echo ''
echo -e "\e[36mCleanup Old Nginx Content\e[0m"
cd /usr/share/nginx/html
rm -rf *
STATUS_CHECK

echo ''
echo -e "\e[36mExtracting Archive\e[0m"
unzip /tmp/frontend.zip
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
STATUS_CHECK

echo ''
echo -e "\e[36mStarting Nginx\e[0m"
systemctl enable nginx
systemctl start nginx
STATUS_CHECK