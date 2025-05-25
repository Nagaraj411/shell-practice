#!/bin/bash


# while IFS= read -r line
# do
#     echo "Processing line: $line"
#     if (find . -name "*.log" -mtime +60); then
#         echo "Deleting old file: $line"
#         rm "$line"
#     else
#         echo "No old files to delete."
#     fi  

# done < variables.sh

while IFS= read -r line

do
    echo $line
done < variables.sh