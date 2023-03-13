#!/usr/bin/env bash
################################
## put this script to the same path with standalone.jar
## where will deploy the lib .jar within /lib/*.jar into standalone.jar
################################
opt=$1  # -f --force  --- force to add new jar

usage(){
    echo "usage: deploy-lib.sh [OPTIONS]"
    echo 'OPTIONS:'
    echo '  -h  --help   for help'
    echo '  -f  --force  force to add new jar, default to reject'
    exit 0
}

JAR_BIN=$(which jar)
JAVA_BIN=$(which java)
force_opt=$9
if [ $opt ];then
  if [[ $opt = -h || $opt = '--help' ]];then
      usage
  fi
  if [[ $opt = -f || $opt = '--force' ]];then
      force_opt='force'
  fi
fi

## pending
## check dependency from jar-dependency.jar
checkdependency() {
  app=$1
  jar=$2

  jarlibroot=/usr/local/lib

  result=$("$JAVA_BIN" -jar $jarlibroot/jar-dependency.jar -cm  $app $jar)
  echo $result
}
## end pending


putlocaljar(){
  app=$1
  jar=$2
  force=$3  ## for add new jar

   ## check dependency, if required new dependencies, skip
   #      dependencies=$(checkdependency $app $jar)
   #      if [ ${#dependencies} -gt 0 ];then
   #          echo fail to depoy lib for dependencies: >/dev/stderr
   #          for it in $dependencies;do
   #            echo $'\t'$it >/dev/stderr
   #          done
   #          continue
   #      fi
   #   ## end dependency

  ## start deploy jar

  jarlib=$(basename $jar)
  echo + $jarlib > /dev/stderr
  jarok=$("$JAR_BIN" tf $app | grep $jarlib)
    
  if [ ! $jarok ];then
    if [ $force ];then
      ## means new jar
      ## .war for WEB-INF, .jar for BOOT-INF
      local ext=${app##*.}  ##extension of app
      local INF
      if [ $ext = 'war' ];then
        INF=WEB-INF
      else
        INF=BOOT-INF 
      fi
      echo "$INF/lib/$jarlib" > /dev/stderr
      jarok="$INF/lib/$jarlib"
    else
      echo "$jarlib not found in $app, use '-f' to force to add into" > /dev/stderr
      continue
    fi
  fi

  if [ $jarok ];then
    ## update lib
    jardir=$(dirname $jarok)
    if [ ! -d $jardir ];then
      echo mkdir -p $jardir > /dev/stderr
      mkdir -p $jardir
    fi

    # core
    echo mv $jar $jardir > /dev/stderr
    mv $jar $jardir
    echo jar 0uf $app $jarok > /dev/stderr
    "$JAR_BIN" 0uf $app $jarok
    echo $jarok

    ## rm after jar updated
    echo rm -f $jarok > /dev/stderr
    rm -f $jarok
  fi
}


putlocaljars() {
  app=$1
  libroot=$2
  force=$3  ## for add new jar

  for jar in $(ls $libroot/*)
  do
     # only .jar
     if [[ ! $jar = *.jar ]];then
        continue
     fi
     # skip -standalone.jar
     if [ $jar = *-standalone.jar ];then
        continue
     fi
     
     putlocaljar $app $jar $force
  done
}


## main


## the the only standalone
search_one() {
  pattern=$1

  result=$(ls $pattern 2> /dev/null)
  if [ -z "$result" ];then
    echo no $pattern files found ! > /dev/stderr
    exit
  fi
  if [ ! -f "$result" ];then
    echo multi $pattern files found ! > /dev/stderr
    exit
  fi
  echo $result
}


## main
if [ -z "$(ls lib/*.jar 2>/dev/null)" ];then
   echo 'no lib to deploy !' >/dev/stderr
   exit
fi

#check standalone
standalone=$(search_one "app.jar *-standalone.jar *.war")
if [ ! $standalone ];then
    echo 'no app.jar, *-standalone.jar, *.war found !' >/dev/stderr
    exit
fi
standalone_basename=$(basename $standalone)
standalone_filename=${standalone_basename%.*}
standalone_ext=${standalone##*.}

## get fixapp to be deploy
unset fixapp
if [ $standalone_ext = 'war' ];then
   fixapp=$standalone_filename.war.FIX
else
   fixapp=$standalone_filename.jar.FIX
fi

if [ ! -f $fixapp ];then
  echo cp $standalone $fixapp > /dev/stderr
  cp $standalone $fixapp

  #echo putlocaljars $fixapp lib
  jars=$(putlocaljars $fixapp lib $force_opt)
  echo ... > /dev/stderr
  if [[ -z "$jars" ]];then
     rm -f $fixapp
  fi
  for j in $jars;do 
     echo "=> $j"
  done
else
  echo "$fixapp exists, means deployed lib done !" > /dev/stderr
fi



## clean up

cleanup() {
  ext=$1
  if [[ $ext = jar ]];then 
    if [ -d BOOT-INF ];then
      rm -rf BOOT-INF/lib/* 2> /dev/null
      rmdir BOOT-INF/lib 2> /dev/null
      rmdir BOOT-INF 2> /dev/null
    fi
  fi
  
  if [[ $ext = war ]];then
    if [ -d WEB-INF ];then
      rm -rf WEB-INF/lib/* 2> /dev/null
      rmdir WEB-INF/lib 2> /dev/null
      rmdir WEB-INF 2> /dev/null
    fi
  fi
}

cleanup $standalone_ext
