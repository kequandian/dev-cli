#!/bin/bash
option=$1

########dependency-cli.jar path########
jar_path=./lib/dependency-cli.jar
compare='-c --compare'
parse='-p --parse'
version='-v --version'
#############debug############
#echo jar_path=${jar_path}
#echo option=${option}
##############################

if [ ! $option ]
then
	echo ''
	echo 'Usage: dependency Options [Variables...] '
	echo 'e.g. dependency -p ./lib/test.jar'
	echo '用于Jar包依赖输出 和 Maven module依赖对比'
	echo ''
	echo 'Options:'
	echo '  -c, --compare [Maven module I] [Maven module II]  对比两个Maven module依赖情况并生成JSON文件'
	echo '  -p, --parse [Jar Path]  解析Jar包依赖并生成JSON文件'
	echo '  -v, --version  输出当前工具版本信息'
	exit
fi

if [[ $compare =~ $option ]]
then
	java -jar $jar_path $*
elif [[ $parse =~ $option ]]
then
	java -jar $jar_path $*
elif [[ $version =~ $option ]]
then
	java -jar $jar_path $*
fi

