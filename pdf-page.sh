#!/usr/bin/env sh

abs_path=()
os_name=$(uname)
if [[ $os_name == 'Darwin' ]];then  ## MAC
   abs_path=$(greadlink -f "$0")
else                                ## Windows
   abs_path=$(readlink -f "$0")
fi
abs_path=$(dirname $abs_path)

java -jar $abs_path/lib/pdf-page-all.jar $@

