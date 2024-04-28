#!/bin/sh
newline() {
  echo $1                       > Dockerfile.nocache
}
putline() {
  echo $1                       >> Dockerfile.nocache  
}

build_Dockerfile_nocache(){
newline '#git-stage'
putline 'FROM zelejs/allin-web:m2 as m2'
putline ''
putline '#src-stage'
putline 'FROM allin-web:src as src'
putline ''
putline '#build-stage'
putline 'FROM maven:3.6-adoptopenjdk-11 as build'
putline 'WORKDIR /root/.m2'
putline 'COPY --from=m2 /root/.m2/settings.xml .'
putline 'WORKDIR /usr/src'
putline 'COPY --from=src /usr/src/pom.xml  ./pom.xml'
putline 'COPY --from=src /usr/src/src ./src'
putline ''
putline 'CMD mvn -DskipStandalone=true -Dmaven.test.skip=true clean deploy'
}

###########################################
image='allin-web:build-install-1'
###########################################
# if [ ! -f Dockerfile.nocache ];then 
   build_Dockerfile_nocache
# fi

docker build -f Dockerfile.nocache . --force-rm -t $image --no-cache
if [ $? != 0 ];then
  echo build $image failure !
  exit
fi

# do as: mvn clean
#if [[ ! -z $(ls ./target) ]];then
if [ -d target ];then
   rm -rf target/*
fi
if [ ! -e target ];then
  mkdir target
fi
#fi

docker run --privileged --rm -v $HOME/.m2/repository:/root/.m2/repository $image
if [ $? != 0 ];then
  echo run $image failure !
  exit
fi

## clean up
docker image rm $image 2> /dev/null
rm -f Dockerfile.nocache
