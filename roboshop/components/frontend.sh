#!/bin/bash

USER_ID=$(id -u)
if [ ${USER_ID} -ne 0 ]; then
  echo You need to be root user to execute this program
  exit 1
fi

echo -e "\e[36mInstalling NGINX\e[0m"
yum install nginx -y
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e[0m"
  exit 2
fi
echo ''
echo -e "\e[36mDownloading Frontend software\e[0m"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e[0m"
  exit 2
fi
echo ''
echo -e "\e[36mCleanup Old Nginx Content\e[0m"
cd /usr/share/nginx/html
rm -rf *
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e[0m"
  exit 2
fi
echo ''
echo -e "\e[36mExtracting Archive\e[0m"
unzip /tmp/frontend.zip
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e[0m"
  exit 2
fi
echo ''
echo -e "\e[36mStarting Nginx\e[0m"
systemctl enable nginx
systemctl start nginx
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e[0m"
  exit 2
fi