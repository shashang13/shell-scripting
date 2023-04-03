#!/bin/bash

set -x

createEc2(){
  PRIVATE_IP=$(aws ec2 run-instances \
            --image-id ${AMI_ID} \
            --security-group-ids ${SG_ID} \
            --instance-type t3.micro \
            --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
            --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
            --user-data "file://ec2userdata.txt" \
            |jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

  sed -e "s/COMPONENT/${COMPONENT}/" -e "s/IPADDRESS/${PRIVATE_IP}/" route53.json > /tmp/route53.json
  aws route53 change-resource-record-sets --hosted-zone-id ${HOSTED_ZONE_ID} --change-batch file:///tmp/route53.json
}

################## Main Program ##############

if [ -z "$1" ]; then
  echo -e "\e[31mInput machine name is needed\e[0m"
fi

export COMPONENT=$1
HOSTED_ZONE_ID="Z03359161XEIHWG682X1"

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice"|jq '.Images[].ImageId'|sed -e 's/"//g')
echo ${AMI_ID}
AMI_ID="ami-0b55b2bdf150da270"

SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=allow-all-sg"|jq '.SecurityGroups[].GroupId'|sed -e 's/"//g')
echo ${SG_ID}

if [ "$1" == "all" ]; then
  for component in cart catalogue frontend redis mysql mongodb payment rabbitmq shipping user dispatch
  do
    COMPONENT=${component}
    createEc2
  done
else
  createEc2
fi
