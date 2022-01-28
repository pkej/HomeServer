#!/bin/bash

# First get some default data from the environment

DOCKERDIR=`pwd`
SECRETSDIR=$DOCKERDIR/secrets
USERNAME=`id -u -n`
PUID=`id -u`
PGID=`id -g`
PROJECTNAME=HomeServer

# Get data from the command line, if any
while getopts u:g:p:n:t: flag
do
    case "${flag}" in
        u) PUID=${OPTARG};;
        g) PGID=${OPTARG};;
        p) PROJECTNAME=${OPTARG};;
        n) USERNAME=${OPTARG};;
        t) TZ=${OPTARG};;
    esac
done

PROJECTNAME=`cat $SECRETSDIR/projectname`
USERNAME=`cat $SECRETSDIR/username`
PUID=`cat $SECRETSDIR/puid`
PGID=`cat $SECRETSDIR/pgid`
TZ=`cat $SECRETSDIR/tz`

DOMAINNAME0=`cat $SECRETSDIR/domainname0`
CF_API_TOKEN0=`cat $SECRETSDIR/cf_api_token0`
CF_EMAIL0=`cat $SECRETSDIR/cf_email0`
CF_API_KEY0=`cat $SECRETSDIR/cf_api_key0`
CF_ZONE_ID0=`cat $SECRETSDIR/cf_zone_id0`

DOMAINNAME1=`cat $SECRETSDIR/domainname1`
CF_API_TOKEN1=`cat $SECRETSDIR/cf_api_token1`
CF_EMAIL1=`cat $SECRETSDIR/cf_email1`
CF_API_KEY1=`cat $SECRETSDIR/cf_api_key1`
CF_ZONE_ID1=`cat $SECRETSDIR/cf_zone_id1`

TRAEFIK_PILOT_TOKEN=`cat $SECRETSDIR/traefik_pilot_token`

MARIADB_ROOT_PASSWORD=`cat $SECRETSDIR/mariadb_root_password`
LDAP_ADMIN_USERNAME=`cat $SECRETSDIR/ldap_admin_username`
LDAP_ADMIN_PASSWORD=`cat $SECRETSDIR/ldap_admin_password`
LDAP_CONFIG_ADMIN_USERNAME=`cat $SECRETSDIR/ldap_config_admin_username`
LDAP_CONFIG_ADMIN_PASSWORD=`cat $SECRETSDIR/ldap_config_admin_password`
LDAP_USERS=`cat $SECRETSDIR/ldap_users`
LDAP_PASSWORDS=`cat $SECRETSDIR/ldap_passwords`
DOMAINROOT0=`cat $SECRETSDIR/domainroot0`
DOMAINTLD0=`cat $SECRETSDIR/domaintld0`


# Backup old .env file
mv .env .env--

# This will take all environment variables that are defined
# and replace them in the template

eval "cat <<EOF
$(<.env-template)
EOF
" 2> /dev/null > .env
echo "finished"

echo -n $USERNAME > $SECRETSDIR/username
echo -n $PUID > $SECRETSDIR/puid
echo -n $PGID > $SECRETSDIR/pgid
echo -n $PROJECTNAME > $SECRETSDIR/projectname
echo -n $TZ > $SECRETSDIR/tz

cp .env dc-files/.env