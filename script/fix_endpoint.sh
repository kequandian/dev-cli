#!/usr/bin/env bash

dist_root=/var/www/html

if [ $1 ];then
   dist_root=$1
fi

if [ -f $dist_root/config.js ];then
   endpoint=${ENDPOINT}
   if [[ $endpoint == http* ]];then
      endpoint=$endpoint
   else
      endpoint="http://$endpoint"
   fi
   endpoint=${endpoint//\//\\\/}

   if [ ${ENDPOINT} ];then
      # window.ZEle.endpoint = 'http://localhost:8080';
      sed -i "s/window.ZEle.endpoint[[:space:]]*=[[:space:]]*'http:\/\/[a-z0-9\.]*:[0-9]*/window.ZEle.endpoint = $endpoint/" $dist_root/config.js
   fi
fi
