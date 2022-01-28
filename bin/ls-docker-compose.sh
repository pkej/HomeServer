#!/bin/bash
unamestr=$(uname)
if [ "$unamestr" = 'Linux' ]; then
  export $(grep -v '^#' .env | xargs -d '\n')
elif [ "$unamestr" = 'FreeBSD' ]; then
  export $(grep -v '^#' .env | xargs -0)
elif [ "$unamestr" = 'Darwin' ]; then
  source .env
fi
NEWLINE=$'\n'
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
DOCKERFILES=$DOCKERCOMPOSEDIR/*.yml

if [ $(basename -- $DOCKERFILES) = '*.yml' ]; then
  echo "No enabled projects"
else
  for dockerfile in $DOCKERFILES
  do
      MANIFESTS="${MANIFESTS} $(basename -- $dockerfile)"
      PROJECTNAMES="${PROJECTNAMES} $(basename -s .yml -- $dockerfile)"
      PROJECTNAME=$(basename -s .yml -- $dockerfile)
      RUNNING=`docker ps | grep $PROJECTNAME`
      if [ -z $RUNNING ]; then
        printf "${NC}Enabled: ${ORANGE}$(basename -s .yml -- $dockerfile)${NEWLINE}${NC}"
      else
        printf "${NC}Running: ${GREEN}$(basename -s .yml -- $dockerfile)${NEWLINE}${NC}"
      fi
      
  done
fi

echo ""

DOCKERFILES=$DOCKERCOMPOSEDIR/*.yml-disabled
if [ $(basename -- $DOCKERFILES) = '*.yml-disabled' ]; then
  echo "No disabled projects"
else
  for dockerfile in $DOCKERFILES
  do
    MANIFESTS="${MANIFESTS} $(basename -- $dockerfile)"
    PROJECTNAMES="${PROJECTNAMES} $(basename -s .yml-disabled -- $dockerfile)"
    printf "${NC}Disabled: ${RED}$(basename -s .yml-disabled -- $dockerfile)${NEWLINE}${NC}"
  done
fi

