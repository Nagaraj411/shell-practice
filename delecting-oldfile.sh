#!/bin/bash

while IFS= read -r line          #Internal field separator
do
echo "Processing line: $line"
  if (find . -name *.log * -mtime +14); then
    echo "Deleting old file: $line"
    rm "$line"
  else
    echo "Keeping file: $line"
  fi

done
