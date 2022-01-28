#!/bin/bash
unamestr=$(uname)
if [ "$unamestr" = 'Linux' ]; then
  export $(grep -v '^#' .env | xargs -d '\n')
elif [ "$unamestr" = 'FreeBSD' ]; then
  export $(grep -v '^#' .env | xargs -0)
elif [ "$unamestr" = 'Darwin' ]; then
  source .env
fi

helpFunction()
{
   echo ""
   echo "Usage: $0 -u username || -d default"
   echo -e "\t-u username to set files editable"
   echo -e "\t-d default to set files back to correct for services"
   exit 1 # Exit script after printing help
}

defaultFunction()
{
    echo "default: $default"
    sudo chown -R root $SECRETSDIR
    sudo chgrp -R root $SECRETSDIR
    sudo chmod -R 600 $SECRETSDIR
    sudo chown -R root $SECRETSDIR
    sudo chgrp -R docker $CONFIGDIR
    sudo chmod -R 600 $CONFIGDIR

}

userFunction()
{
    echo "user: $user"
    sudo chown -R $USERNAME $SECRETSDIR
    sudo chgrp -R docker $SECRETSDIR
    sudo chmod -R 774 $SECRETSDIR
    sudo chown -R $USERNAME $CONFIGDIR
    sudo chgrp -R docker $CONFIGDIR
    sudo chmod -R 774 $CONFIGDIR
    sudo chown -R $USERNAME $DATADIR
    sudo chgrp -R docker $DATADIR
    sudo chmod -R 774 $DATADIR
    sudo chown -R $USERNAME $MEDIADIR
    sudo chgrp -R docker $MEDIADIR
    sudo chmod -R 774 $MEDIADIR
}

while getopts "u:d:" opt
do
   case "$opt" in
      u ) user="$OPTARG" ;;
      d ) default="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$user" ]
then
    if [ -z "$default" ]
    then
        echo "Some or all of the parameters are empty";
        helpFunction
    else
        defaultFunction
    fi
else
    userFunction
fi
