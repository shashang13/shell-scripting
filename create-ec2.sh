#!/bin/bash

if [ -z "$1" ]; then
  echo "\e[31mInput machine name is needed\e[0m"
fi

COMPONENT=$1


AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice"|jq '.Images[].ImageId'|sed -e 's/"//g')
echo ${AMI_ID}

SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=allow-all-sg"|jq '.SecurityGroups[].GroupId'|sed -e 's/"//g')

aws ec2 run-instances \
--image-id ${AMI_ID} \
--security-group-ids ${SG_ID} \
--instance-type t3.micro \
--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}]" \
--instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"