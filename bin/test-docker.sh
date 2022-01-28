#!/bin/bash

PROGNAME=$(basename $0)
unamestr=$(uname)
if [ "$unamestr" = 'Linux' ]; then
  export $(grep -v '^#' .env | xargs -d '\n')
elif [ "$unamestr" = 'FreeBSD' ]; then
  export $(grep -v '^#' .env | xargs -0)
fi
source .dev 

function error_exit
{

#   ----------------------------------------------------------------
#   Function for exit due to fatal program error
#       Accepts 1 argument:
#           string containing descriptive error message
#   ---------------------------------------------------------------- 

    echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
    exit 1
}

function listServices()
{
    ext=$1
    header=$2
    SERVICES=$DOCKERCOMPOSEDIR/*$ext
    for service in $SERVICES
    do
        FILENAME="$(basename -- $service)"
        BASENAME=`echo "$FILENAME" | cut -d'.' -f1`
        echo -e "\t${BASENAME}"
    done
}

function serviceStatuses()
{
    if [ $1 == "active" ] || [ $1 == "enabled" ]
    then
        ext=".yml"
        echo "Active services:"
        listServices $ext
    elif [ $1 == "disabled" ] || [ $1 == "inactive" ]
    then
        ext=".yml.disabled"
        echo "Disabled services:"
        listServices $ext
    elif [ $1 == $1 ]
    then
        error_exit "You can only list services that are: active|inactive|enabled|disabled"
    fi
}
function services()
{
    serviceStatuses active
    serviceStatuses disabled
}

_contains()
{  # Check if space-separated list $1 contains line $2
  echo "$1" | tr ' ' '\n' | grep -F -x -q "$2"
}

function commands()
{
    activeServices="$(listServices .yml)"
    inactiveServices="$(listServices .yml.disabled)"
    serviceStatus="service doesn't exist"
echo $activeServices
echo $inactiveServices
_contains ${activeServices} ${2}
    if _contains ${activeServices} ${2}
    then
        serviceStatus="active"
    elif _contains "${inactiveServices}" "${2}"
    then
        serviceStatus="inactive"
    fi 

    echo "Service status of $2 is: $serviceStatus"
exit
    if [ -z $1 ]
    then
        error_exit "First argument must be a command: up|down|list|enable|disable"
    elif [ $1 == "list" ]
    then
        if [ -z $2 ]
        then
            services
            exit 0
        elif [ $2 ]
        then
            serviceStatuses $2
            exit 0
        fi
    fi

    # active services can do the following: disable, deactivate, up or down.
    if [ $serviceStatus == "active" ]
    then
        case $1 in
            "up")
                echo "up"
                ;;
            "down")
                echo "down"
                ;;
            "deactivate")
                echo "deactivate"
                ;;
            "disable")
                echo "disable"
                ;;
            *)
                echo "error active"
                ;;
        esac
    elif [ $serviceStatus == "inactive" ]
    then
        case $1 in
            "activate")
                echo "activate"
                ;;
            "enable")
                echo "enable"
                ;;
            *)
                echo "error inactive"
                ;;
        esac
    fi
    exit

    if [ $1 == "up" ] || [ $1 == "down" ] || [ $1 == "enable" ] || [ $1 == "disable" ] || [ $1 == "deactivate" ] || [ $1 == "activate" ]
    then
        if [ -z $2 ]
        then
            echo "Second argument must be an active service: "
            serviceStatuses active
            error_exit "Missing second argument: service"
        elif [ $serviceStatus == "active" ]
        then
            if [ $1 == "up" ] || [ $1 == "down" ] || [ $1 == "enable" ] || [ $1 == "deactivate" ]
            then
                error_exit "The service is inactive."
            elif [ $1 == "enable" ] || [ $1 == "activate" ]
            then
                echo "Enabling service $2"
                sudo mv $DOCKERCOMPOSEDIR/$2.yml.disabled $DOCKERCOMPOSEDIR/$2.yml
                exit
            fi
        elif [ $serviceStatus == "active" ]
        then
            if [ $1 == "enable" ] || [ $1 == "activate" ]
            then
                echo "The service is active already"
            elif [ $1 == "disable" ] || [ $1 == "deactivate" ]
            then
                echo "Disabling service $2"
                sudo mv $DOCKERCOMPOSEDIR/$2.yml $DOCKERCOMPOSEDIR/$2.yml.disabled
                exit
            elif [ $1 == "up" ] || [ $1 == "down" ]
            then
                echo docker-compose -f $2 $1 -d
                exit
            fi
        fi
        exit
    fi
    exit
}

function one()
{   
    commands $@
    ERROMESSAGE=$(docker-compose -f yml/$2.yml up 2>&1)
    if  [ ERROMESSAGE ]
    then
        if [ $(expr "$ERROMESSAGE" : ".*depends on.*") -gt 0 ]
        then
            DEPENDENCY=`sed -n "s/^.*'\(.*\)'.*$/\1/ p" <<< ${ERROMESSAGE}`
            echo $DEPENDENCY
        fi
    fi
}
one $@