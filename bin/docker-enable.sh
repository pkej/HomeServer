#!/bin/bash
unamestr=$(uname)
if [ "$unamestr" = 'Linux' ]; then
  export $(grep -v '^#' .env | xargs -d '\n')
elif [ "$unamestr" = 'FreeBSD' ]; then
  export $(grep -v '^#' .env | xargs -0)
elif [ "$unamestr" = 'Darwin' ]; then
  source .env
fi

FILE_DISABLED=$DOCKERCOMPOSEDIR/$1.yml.disabled
FILE_ENABLED=$DOCKERCOMPOSEDIR/$1.yml
if [ -z $1 ]; then
  echo "You need to supply a service name e.g. 'transmission'"
  exit
fi
if test -f "$FILE_DISABLED"; then
    echo "Enabling docker file: $FILE_ENABLED"
    sudo mv $FILE_DISABLED $FILE_ENABLED
elif test -f "$FILE_ENABLED"; then
    echo "File $FILE_ENABLED is already enabled."
else
    echo "No such docker file to enable: $FILE_ENABLED"
fi