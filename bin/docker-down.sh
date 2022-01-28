#!/bin/bash
unamestr=$(uname)
if [ "$unamestr" = 'Linux' ]; then
  export $(grep -v '^#' .env | xargs -d '\n')
elif [ "$unamestr" = 'FreeBSD' ]; then
  export $(grep -v '^#' .env | xargs -0)
elif [ "$unamestr" = 'Darwin' ]; then
  source .env
fi
echo $USERNAME
function all()
{
  DOCKER_PATH=$DOCKERCOMPOSEDIR/*.yml
  for dockerfile in $DOCKER_PATH
  do
      MANIFESTS="${MANIFESTS} -f $dockerfile"
  done

  MANIFESTS="docker-compose ${MANIFESTS} -p ${PROJECTNAME} down --remove-orphans"
  echo $MANIFESTS
  $MANIFESTS
  #docker-compose $MANIFESTS
  #sudo $BINDIR/permissions.sh -u $USERNAME
}

function one()
{
  FILE_DISABLED=$DOCKERCOMPOSEDIR/$1.yml.disabled
  FILE_ENABLED=$DOCKERCOMPOSEDIR/$1.yml
  if test -f "$FILE_DISABLED"; then
      echo "Service $1 is disabled: $FILE_ENABLED"
      echo "aborting"
      return
  elif test -f "$FILE_ENABLED"; then
      MANIFESTS="docker-compose -f ${FILE_ENABLED} -p ${PROJECTNAME} down --remove-orphans"
      echo $MANIFESTS
      $MANIFESTS
      #sudo "$BINDIR/permissions.sh" "-u $USERNAME"
      return
  else
      echo "No service $1 to shut down"
      return
  fi
}


if [ -z $1 ]
then
  echo "You need to supply a service name e.g. 'transmission' or the reserved 'all'"
  exit
elif [ $1 == 'all' ] || [ $1 == 'All' ]
then
  echo "Starting all services"
  all
  exit
elif [ $1 == $1 ]
then
  echo "Starting service $1"
  one $1
  exit
fi


# need to set manually since it normally uses current directory as project name
#echo $PROJECT_NAME
#echo $@
#DOCKER_PATH=$DOCKERCOMPOSEDIR/*.yml



#echo $MANIFESTS

#$BINDIR/ls-docker-compose.sh $@ up -d --remove-orphans
#sudo $BINDIR/permissions.sh -u $USERNAME
