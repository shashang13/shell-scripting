#!/bin/bash

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice"|jq '.Images[].ImageId'|sed -e 's/"//g')
echo AMI_ID
#aws ec2 run-instances --image-id ami-0abcdef1234567890 --instance-type t2.micro