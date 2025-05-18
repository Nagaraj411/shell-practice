#!/bin/bash

USERID=$(id -u)
if [ $USERID -eq 0 ]    
then
 echo "Running with sudo user"
else 
    echo "Please run with sudo user"
    exit 1
fi