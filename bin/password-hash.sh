#!/bin/bash
if [ -z $1 ]; then
  echo "You need to supply a password e.g. 'my-password'"
  exit
fi
echo hasing password: $1
#docker run authelia/authelia:latest authelia hash-password '$1' -i 1 -l 16 -p 8 -m 1024 --salt dHlwZSBvciBwYXN0ZSBhIGNvZGUK
docker run authelia/authelia:latest authelia hash-password '$1' -i 1 -l 16 -p 8 -m 1024 c2Vzc2lvbi5zZWNyZXQuY3Ixc3QxbmEuU3lzdGVt