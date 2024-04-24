#!/bin/bash

source ./common.sh

check_root



dnf module disable nodejs -y &>>LOGFILE
# $? "Disabling Node js"

dnf module enable nodejs:20 -y &>>LOGFILE
# $? "Enabling Node js 20"

dnf install nodejs -y &>>LOGFILE
# $? "Installing Node js"

id expense
if [ $? -ne 0 ]
then
  useradd expense &>>LOGFILE
  # $? "Creating user expense"
else
  echo -e "user expense is already exist...$Y SKIPPING $N"
fi

mkdir -p /app &>>LOGFILE
# $? "Creating app Directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>LOGFILE
# $? "Downloading backend code"

cd /app &>>LOGFILE
rm -rf /app/*
unzip /tmp/backend.zip &>>LOGFILE
# $? "Extracted backend code"

npm install &>>LOGFILE
# $? "Installing Node js dependencies"

cp /home/ec2-user/Expenses/backend.service /etc/systemd/system/backend.service &>>LOGFILE
# $? "Copied backend service"

systemctl daemon-reload &>>$LOGFILE
# $? "Daemon Reload"

systemctl start backend &>>$LOGFILE
# $? "Starting backend"

systemctl enable backend &>>$LOGFILE
# $? "Enabling backend"

dnf install mysql -y &>>$LOGFILE
# $? "Installing MySql client"

mysql -h db.chandureddy.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
# $? "Schema Loading"

systemctl restart backend &>>$LOGFILE
# $? "Restarting the backend"