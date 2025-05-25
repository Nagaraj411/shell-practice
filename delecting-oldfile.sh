#!/bin/bash

while IFS= read -r line          #Internal field separator
do
    echo "Processing line: $line"
  if ( find . -name *.log * -mtime +60 ); then
    echo "Deleting old file: $line"
done
