#!/bin/bash

#Real-Time Use-case: Find the 14 days older files and zip it then move to destination directory

#Test Scenarios:
#Check source and destination dir are present or not
#If present, find the files from source and zip them
#Then move it to destination
#Then remove the files from source dir

# === Auto re-run with sudo if not root ===
#if [ "$EUID" -ne 0 ]; then
#    echo "Re-running as root using sudo..."
#    exec sudo "$0" "$@"
#fi

SOURCE_DIR=$1  #passing it as runtime arguments
DEST_DIR=$2
DAYS=${3:-14}  #syntax to pass 3rd argument as optional. If not pass default value is 14
START_TIME=$(date +%s)   #will give time in seconds
USER_ID=$(id -u)         #Good to delete files using root user
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/log/backup-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
#SCRIPT_NAME=$(basename "$0")
LOG_FILE="$LOG_FOLDER/backup.log"

mkdir -p $LOG_FOLDER
echo -e "Script executing at: $Y $(date) $N" | tee -a $LOG_FILE

if [ $USER_ID -eq 0 ]
then 
    echo -e "$G Running with root user... $N" | tee -a $LOG_FILE
else
    echo -e "$R Error: Run with root user $N" | tee -a $LOG_FILE
    exit 1
fi

USAGE(){
    echo -e "$R USAGE :: $N sh 15-backup.sh <source_dir> <dest_dir> <days(optional)>"
    exit 1
}
#Passing 2 args as mandatory. If not passed throw an error
if [ $# -lt 2 ]
then
    USAGE
fi

#Check Source and dest directories are exists or not
if [ ! -d $SOURCE_DIR ]
then
    echo -e "$R Source Dir $SOURCE_DIR doesn't exists $N"
    exit 1
fi

if [ ! -d $DEST_DIR ]
then
    echo -e "$R Destination Dir $DEST_DIR doesn't exists $N"
    exit 1
fi

#Find files in the source directory
FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS)

#Check files are present or empty
#Then give zip file name with timestamp
#Zip them in Dest dir using ZIP command
#If successfully ZIPPED then delete the files from Source Dir
#Schedule it using cron Tab to run automatically
if [[ -n "$FILES" ]]   #-n not empty -z empty. can use anything
then
    echo "Files found to zip are: $FILES"
    TIMESTAMP=$(date +"%F-%H-%M-%S")  # It gives YYYY-MM-DD HH:MM:SS time
    ZIP_FILE=$DEST_DIR/app-logs-$TIMESTAMP.zip #created destination dir with .zip extension
    echo -e "$R Printing ZIP File name $ZIP_FILE $N"
    #echo $FILES | xargs -n 1 | zip -@ $ZIP_FILE
    #echo $FILES | tr ' ' '\n' | zip -@ $ZIP_FILE # ("this will not work if file names have spaces")
    #find "$SOURCE_DIR" -name "*.log" -mtime +"$DAYS" | zip -@ "$ZIP_FILE"
    find "$SOURCE_DIR" -name "*.log" -mtime +"$DAYS" -print0 | xargs -0 zip -@ "$ZIP_FILE"  #Using -print0 and xargs -0 to handle file names with spaces is this works

    if [[ -f "$ZIP_FILE" ]]
    then
        echo "Succesfully ZIP files are created"

        find "$SOURCE_DIR" -name "*.log" -mtime +"$DAYS" -print0 | while IFS= read -r -d '' filepath
        do
            echo -e "Deleting the log files: $Y $filepath $N" | tee -a $LOG_FILE
            echo -e "File name : $G $filepath $N"
            rm -rf "$filepath"
        done
        echo -e "Log files older than "$DAYS" days are deleted from Source Dir $G Sucessfully... $N"
    else
        echo -e "ZIP creation $R FAILED $N"
        exit 1
    fi
else
    echo -e "No files found. $Y SKIPPING $N"
fi