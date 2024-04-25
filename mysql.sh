#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB password:"
read -s mysql_root_password

dnf install mysql-serddver -y &>>$LOGFILE
#VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>>$LOGFILE
#VALIDATE $? "Enabling MySQL Server" 

systemctl start mysqld &>>$LOGFILE
#VALIDATE $? "Starting MySQL Server" 

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
mysql -h db.daws-78s.cloud -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    #VALIDATE $? "MySQL root password setup"
else
    echo -e "MySQL root password is already setup...$Y SKIPPING $N"
fi