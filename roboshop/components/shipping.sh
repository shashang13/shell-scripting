#1. Install Maven, This will install Java too
#
#```sql
## yum install maven -y
#```
#
#1. As per the standard process, we always run the applications as a normal user.
#
#Create a user
#
#```sql
## useradd roboshop
#```
#
#1. Download the repo
#
#```bash
#$ cd /home/roboshop
#$ curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip"
#$ unzip /tmp/shipping.zip
#$ mv shipping-main shipping
#$ cd shipping
#$ mvn clean package
#$ mv target/shipping-1.0.jar shipping.jar
#```
#
#1. Update SystemD Service file
#
#    Update `CARTENDPOINT` with Cart Server IP.
#
#    Update `DBHOST` with MySQL Server IP
#
#2. Copy the service file and start the service.
#
#```sql
## mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service
## systemctl daemon-reload
## systemctl start shipping
## systemctl enable shipping
#```