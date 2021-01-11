#!/bin/sh

## get name for snapshot
archiva=$(basename $(dirname $(readlink -f $0)))
target=$archiva-DEPLOY-SNAPSHOT.tar

## archiva config files
echo step 1 =>pack all filtered files
tar -cvf  $target \
    --exclude=*.jar --exclude=*.jar.* --exclude=*rollback* \
    --exclude=./mysql/data/* \
    --exclude=./attachments --exclude=./images \
    --exclude=./web/dist \
    --exclude=*.log \
    --exclude=*.gz --exclude=*.tar --exclude=*.swp \
    --exclude=.git \
    --exclude=node_modules \
    --exclude=.idea \
    . 

## add ./api/app.jar
if [ -f ./api/app.jar ];then
   echo step 2 => pack ./api/app.jar
   tar -uvf $target ./api/app.jar 
else
   echo warning: no ./api/app.jar found !
fi

## add web/dist
if [ -d ./web/dist ];then
   echo step 2 => pack ./web/dist
   tar -uvf $target ./web/dist
else
   echo warning: no ./web/dist found !
fi

## todo, add database dump script
