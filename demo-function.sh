#!/bin/bash

USERID=$(id -u)
 if [ $USERID -eq 0 ]    then
 echo "Please run with sudo user"
    else 
    echo "Running with sudo user"
    exit 1
    if
