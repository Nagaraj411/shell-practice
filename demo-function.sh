#!/bin/bash

#Use case - Install Mysql, nginx, python3 packages by using function

#check whether you are running with sudo user

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "❌ Run with sudo user to install packages" #first lone print message if 0 equal to 0

else
    echo "✅ Running with sudo user..."

fi          #9-15 line are root user checking commands

#function to validate package installed succesfully or not

VALIDATE(){

    if [ $1 -eq 0 ]
    then
        echo "✅ $2 installed succesfully..."
    else
        echo "❌ $2 failed to install..."
        exit 1
    fi
}            #19-28 line are validate function for all packages (Mysql, nginx &  python3)


#Installing Mysql package
dnf list installed mysql
if [ $? -ne 0 ]     #0 not equal 0 --false so install MySql
then
    echo "✅ MySql is not installed. Installing now... "
    dnf install mysql -y
    VALIDATE $? mysql
else
    echo "Mysql already installed. Nothing to do"       #1 not equal 0 --True already installed MySql
fi           #32-40 line are mysql package installation commands

#Installing nginx package
dnf list installed nginx
if [ $? -ne 0 ]     #0 not equal 0 --false so install nginx
then
    echo "✅ nginx is not installed. Installing now... "
    dnf install nginx -y
    VALIDATE $? nginx
else
    echo "nginx already installed. Nothing to do"       #1 not equal 0 --True already installed nginx
fi      #55-64 line are nginx package installation commands