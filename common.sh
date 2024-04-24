#!/bin/bash


set -e
handle_error(){
    echo "Error occured at line no: $1 and Error command is: $2"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="e\[31m"
G="e\[32m"
Y="e\[33m"
N="e\[0m"


VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R Failure $N"
    exit 3
    else
        echo -e "$2...$G Success $N"
    fi
}

check_root(){
if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access"
    exit 6
else
    echo "You are root user"
fi
}