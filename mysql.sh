#!/bin/bash

source ./common.sh

handle_error
check_root

echo "Please enter DB Password:"
read -s mysql_root_password

dnf install mysql-server -y &>>$LOGFILE
#VALIDATE $? "Installing Mysql server"

systemctl enable mysqld &>>$LOGFILE
#VALIDATE $? "Enabling Mysql"

systemctl start mysqld &>>$LOGFILE
#VALIDATE $? "Starting Mysql"

mysql -h db.chandureddy.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
  mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
  #VALIDATE $? "MySQL root password setup"
else
  echo -e "MySQL root passwordis already set up...$Y SKIPPING $N"
fi