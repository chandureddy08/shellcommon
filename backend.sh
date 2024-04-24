#!/bin/bash




dnf module disable nodejs -y &>>LOGFILE
VALIDATE $? "Disabling Node js"

dnf module enable nodejs:20 -y &>>LOGFILE
VALIDATE $? "Enabling Node js 20"

dnf install nodejs -y &>>LOGFILE
VALIDATE $? "Installing Node js"

id expense
if [ $? -ne 0 ]
then
  useradd expense &>>LOGFILE
  VALIDATE $? "Creating user expense"
else
  echo -e "user expense is already exist...$Y SKIPPING $N"
fi

mkdir -p /app &>>LOGFILE
VALIDATE $? "Creating app Directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>LOGFILE
VALIDATE $? "Downloading backend code"

cd /app &>>LOGFILE
rm -rf /app/*
unzip /tmp/backend.zip &>>LOGFILE
VALIDATE $? "Extracted backend code"

npm install &>>LOGFILE
VALIDATE $? "Installing Node js dependencies"

cp /home/ec2-user/Expenses/backend.service /etc/systemd/system/backend.service &>>LOGFILE
VALIDATE $? "Copied backend service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Daemon Reload"

systemctl start backend &>>$LOGFILE
VALIDATE $? "Starting backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enabling backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing MySql client"

mysql -h db.chandureddy.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema Loading"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting the backend"