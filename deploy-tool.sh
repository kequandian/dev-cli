#!/usr/bin/env bash
######################
deploy_container=${CONTAINER}
####################
if [ ! $deploy_container ];then 
   echo env CONTAINER not yet exported !
   exit
fi
#########################

ENDPOINT="http://localhost"
SOCK_OPT='--unix-socket /var/run/docker.sock'

# ## working dir within container => /webapps
# workingdir(){
#    endpoint=$1
#    container=$2

#    # echo "curl -s $endpoint/containers/$container/json | jq '.HostConfig.Binds[] | match(\"([a-z/]+):[a-z/]*/webapps[a-z/]*\").string'"
#    # local binds=$(curl -s $endpoint/containers/$container/json | jq '.HostConfig.Binds[] | match("([a-z/]+):[a-z/]*/webapps[a-z/]*").string')
#    echo curl $SOCK_OPT -s $endpoint/containers/$container/json > /dev/stderr
#    local binds=$(curl $SOCK_OPT -s $endpoint/containers/$container/json | jq '.HostConfig.Binds[] | match("[a-z/]*/webapps:rw").string')
#    # for workingdir_nginx
#    local binds=$(curl $SOCK_OPT -s $endpoint/containers/$container/json | jq '.HostConfig.Binds[] | match("[a-z/]*/usr/share/nginx/html:rw").string')
#    for bind in $binds;do
#       bind=${bind%\"}
#       bind=${bind#\"}
#       bind=${bind%:rw}
#       echo $bind
#    done
# }

getcontainerjsonvalue(){
   endpoint=$1
   container=$2
   jq_filter="$3"

   # echo "curl -s $endpoint/containers/$container/json | jq '.HostConfig.Binds[] | match(\"([a-z/]+):[a-z/]*/webapps[a-z/]*\").string'"
   # local binds=$(curl -s $endpoint/containers/$container/json | jq '.HostConfig.Binds[] | match("([a-z/]+):[a-z/]*/webapps[a-z/]*").string')
   echo "curl $SOCK_OPT -s $endpoint/containers/$container/json | jq $jq_filter" > /dev/stderr
   local result=$(curl $SOCK_OPT -s $endpoint/containers/$container/json | jq $jq_filter)
   result=${result%\"}
   result=${result#\"}
   echo $result
}

# working dir from filesystem
getcomposeworkingdir(){
   endpoint=$1
   container=$2
   echo $(getcontainerjsonvalue $endpoint $container '.Config.Labels."com.docker.compose.project.working_dir"')
}

getcontainerstatus(){
   endpoint=$1
   container=$2
   echo $(getcontainerjsonvalue $endpoint $container '.State.Status')
}

stopcontainer(){
    endpoint=$1
    container=$2
    echo curl $SOCK_OPT -s -X POST $endpoint/containers/$container/stop > /dev/stderr
    curl $SOCK_OPT -s -X POST $endpoint/containers/$container/stop
}
restartcontainer(){
    endpoint=$1
    container=$2
    echo curl $SOCK_OPT -s -X POST $endpoint/containers/$container/restart > /dev/stderr
    curl $SOCK_OPT -s -X POST $endpoint/containers/$container/restart
}

# puttartocontainer(){
#    endpoint=$1
#    container=$2
#    working_dir=$3
#    tarbin=$4

#    echo curl $SOCK_OPT -X PUT ${endpoint}/containers/${container}/archive?path=$working_dir -H \'Content-Type: application/x-tar\' --data-binary @$tarbin > /dev/stderr
#    curl $SOCK_OPT -X PUT ${endpoint}/containers/${container}/archive?path=$working_dir -H 'Content-Type: application/x-tar' --data-binary @$tarbin
#    rm -f $tarbin
# }

buildtar(){
   targetpath=$1

   local dir=${targetpath%\/*}
   local target=${targetpath##*\/}
   if [[ $dir = $target ]];then
      dir='.'
   fi

   wdir=${PWD}
   cd $dir
   if [ ! -f $target.tar.gz ];then
      echo tar zcvf $target.tar.gz $target > /dev/stderr
      tar zcvf $target.tar.gz $target > /dev/null
   fi
   cd $wdir
   echo $targetpath.tar.gz
}

## locate deploy target: [*-standalone.jar, index.html]

# locatedeploytarget(){
#    target=$1
#    local webresult=$(ls $target/index.html 2> /dev/null)
#    if [ ! -z "$webresult" ];then
#       if [ -f $webresult ];then 
#          echo $target
#          return
#       fi
#    fi

#    cd $target
#    local result=$(ls *-standalone.jar 2> /dev/null)
#    if [ -z "$result" ];then
#       echo "$result not found !" > /dev/stderr
#       exit
#    fi
#    if [ ! -f "$result" ];then 
#       echo "multi standalone found: $result !" > /dev/stderr
#       exit
#    fi
#    echo $result
# }


### ################################
### start to deploy
####################################
target=$1

##相对docker-compose。yml的位置
deploy_path=$2
# if [ ! $target ];then
#   echo usage: CONTAINER=<container> deploy-fatjar.sh <target> <deploy_path>
#   exit
# fi

if [ ! $target ];then
  echo 请输入deploy的目标 >  /dev/stderr
fi
# if [ ! -e $target ];then 
#    echo $target not exists ! >  /dev/stderr
#    exit -1
# fi
# deploy_target=$(locatedeploytarget $target)

deploy_target=$target

if [ ! $deploy_target ];then
   echo fail to locate deploy target ! > /dev/stderr
   exit
fi


## stop container first
echo stopping container $deploy_container ..
stopcontainer $ENDPOINT $deploy_container
status=$(getcontainerstatus $ENDPOINT $deploy_container)
if [[ ! $status = 'exited'  ]];then
   echo "fatal: fail to stop $deploy_container: $status !"
   exit
fi
echo stopped: $status !


## build tar
# tarbin=$(buildtar $deploy_target)
 
## put standalone 
echo deploying $deploy_target ..
# working_dir=$(workingdir $ENDPOINT $deploy_container 2> /dev/null)
# puttartocontainer $ENDPOINT $deploy_container $working_dir $tarbin
## local deploy
filesystem_workingdir=$(getcomposeworkingdir $ENDPOINT $deploy_container 2> /dev/null)


if [[ -d $filesystem_workingdir/$deploy_path ]];then
    filesystem_workingdir=$filesystem_workingdir/$deploy_path

   echo rm -rf $filesystem_workingdir/${deploy_target##*/}
   rm -rf $filesystem_workingdir/${deploy_target##*/}
   echo cp -r $deploy_target $filesystem_workingdir
   cp -r $deploy_target $filesystem_workingdir
   
 

fi
echo ls -l $filesystem_workingdir/${deploy_target##*/}
ls -l $filesystem_workingdir/${deploy_target##*/}

## restart container
echo restarting container $deploy_container ..
restartcontainer $ENDPOINT $deploy_container

status=$(getcontainerstatus $ENDPOINT $deploy_container)
echo restarted: $status ..




