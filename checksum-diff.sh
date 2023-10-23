#!/usr/bin/env bash
## define the hash for src_dir
declare -A src_hash
## build the match_dir hash
declare -A match_hash
################################

build_src_hash(){
    local sum_key=
    local sum_path=
    local srclist=$(find $src_dir ! -type d | xargs md5sum)
    for it in ${srclist[@]};do
    if [ ! $sum_key ];then
        sum_key=$it
    elif [ $sum_key ];then
        sum_path=$it
        src_hash[$sum_key]=$sum_path
        unset sum_key
    fi
    done
}

build_match_hash(){
    sum_key=
    sum_path=
    matchlist=$(find $match_dir ! -type d | xargs md5sum)
    for it in ${matchlist[@]};do
    if [ ! $sum_key ];then
        sum_key=$it
    elif [ $sum_key ];then
        sum_path=$it
        match_hash[$sum_key]=$sum_path
        unset sum_key
    fi
    done
}

printout_src_hash(){
  for key in ${!src_hash[@]};do
    value=${src_hash[$key]}
    echo $key $value
  done
}

#print out the src_hash
printout_match_hash(){
  for key in ${!match_hash[@]};do
    value=${match_hash[$key]}
    echo $key $value
  done
}

## print all the src items, followed by the matches items
find_src_diff_for_all(){
  for key in ${!src_hash[@]};do
    src_value=${src_hash[$key]}
    value=${match_hash[$key]}
    echo $key $src_value $value 
  done
}

## diff only
find_src_diff_only(){
  for key in ${!src_hash[@]};do
    if [ ! -v match_hash[$key] ]; then
      src_value=${src_hash[$key]}
      echo $key $src_value 
    #    value=${match_hash[$key]}
    #    echo $key $src_value $value 
    fi
  done
}

## matches only
find_src_diff_matches_only(){
  for key in ${!src_hash[@]};do
    if [ -v match_hash[$key] ];then
       src_value=${src_hash[$key]}
       value=${match_hash[$key]}
       echo $key $src_value $value 
    fi
  done
}


usage(){
    echo 'usage: checksum-diff.sh [OPTION] <src_dir> <match_dir>'
    echo 'OPTION:'
    echo '  --list-src-hash     -- print out the src hash'
    echo '  --list-match-hash   -- print out the match hash'
    echo '  --verbose           -- print out all the items from the src_dir'
    echo '  --diff              -- print out only the diff items from src_dir'
    echo '                      -- no option, the matches items of both'
    exit 0
}

src_dir=
match_dir=
list_src_opt=
list_match_opt=
diff_opt=
verbose_opt=
for opt in $@;do
  if [[ $opt = '--list-src-hash' ]];then
    list_src_opt=$opt
  elif [[ $opt = '--list-match-hash' ]];then
    list_match_opt=$opt
  elif [[ $opt = '--diff' ]];then
    diff_opt=$opt
  elif [[ $opt = '--verbose' ]];then
    verbose_opt=$opt
  elif [ $src_dir ];then
    match_dir=$opt
  else
    src_dir=$opt
  fi
done

if [ ! $src_dir ];then
   usage
fi
if [ ! $match_dir ];then
   usage
fi
if [ ! -d $src_dir ];then
   echo "src dir: $src_dir not exists !"
   usage
fi
if [ ! -d $match_dir ];then
   echo "match dir: $match_dir not exists !"
   usage
fi

## main
build_src_hash
build_match_hash

if [ $list_match_opt ];then
  printout_match_hash
elif [ $list_src_opt ];then
  printout_src_hash
elif [ $diff_opt ];then
  find_src_diff_only
elif [ $verbose_opt ];then
  find_src_diff_for_all
else 
  find_src_diff_matches_only
fi


