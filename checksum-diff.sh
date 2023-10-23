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
build_src_hash_filekey(){
  local srclist=$(find $src_dir ! -type d)
  for it in ${srclist[@]};do
      filekey=$(basename $it)
      src_hash[$filekey]=$it
  done
}

# match-stage
build_match_hash(){
  local sum_key=
  local sum_path=
  local matchlist=$(find $match_dir ! -type d | xargs md5sum)
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
build_match_hash_filekey(){
  local matchlist=$(find $match_dir ! -type d)
  for it in ${matchlist[@]};do
      filekey=$(basename $it)
      match_hash[$filekey]=$it
  done
}
# end match-stage


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
# find_src_diff_for_all(){
#   for key in ${!src_hash[@]};do
#     src_value=${src_hash[$key]}
#     value=${match_hash[$key]}
#     echo $key $src_value $value 
#   done
# }
iter_src_diff_for_all(){
    local srclist=$(find $src_dir ! -type d)
    for it in ${srclist[@]};do
        keyvalue=$(md5sum $it)
        key=${keyvalue%% *}

        value=${match_hash[$key]}
        echo $keyvalue $value 
    done
}
iter_src_diff_for_all_filekey(){
    local srclist=$(find $src_dir ! -type d)
    for it in ${srclist[@]};do
        filekey=$(basename $it)
        value=${match_hash[$filekey]}
        echo $filekey $it $value 
    done
}

# ## diff only
# find_src_diff_only(){
#   for key in ${!src_hash[@]};do
#     if [[ ! ${match_hash[$key]} ]];then
#       src_value=${src_hash[$key]}
#       echo $key $src_value 
#     #    value=${match_hash[$key]}
#     #    echo $key $src_value $value 
#     fi
#   done
# }
iter_src_diff_only(){
  local srclist=$(find $src_dir ! -type d)
  for it in ${srclist[@]};do
    keyvalue=$(md5sum $it)
    key=${keyvalue%% *}

    if [ ! ${match_hash[$key]} ];then
      echo $keyvalue
    fi
  done
}
iter_src_diff_only_filekey(){
  local srclist=$(find $src_dir ! -type d)
  for it in ${srclist[@]};do
    filekey=$(basename $it)

    if [ ! ${match_hash[$filekey]} ];then
      echo $filekey $it
    fi
  done
}

## matches only
# find_src_matches_only(){
#   for key in ${!src_hash[@]};do
#     if [ ${match_hash[$key]} ];then
#        src_value=${src_hash[$key]}
#        value=${match_hash[$key]}
#        echo $key $src_value $value 
#     fi
#   done
# }
iter_src_matches_only(){
  #print out only value
  local out=$1

  local srclist=$(find $src_dir ! -type d)
  for it in ${srclist[@]};do
    keyvalue=$(md5sum $it)
    key=${keyvalue%% *}

    if [ ${match_hash[$key]} ];then
       value=${match_hash[$key]}
       if [ $out ];then
         echo $value 
       else
          echo $keyvalue $value 
       fi
    fi
  done
}
iter_src_matches_only_printout(){
    iter_src_matches_only 'out'
}

iter_src_matches_only_filekey(){
  #print out only value
  local out=$1

  local srclist=$(find $src_dir ! -type d)
  for it in ${srclist[@]};do
    filekey=$(basename $it)

    if [ ${match_hash[$filekey]} ];then
       value=${match_hash[$filekey]}
       if [ $out ];then
          echo $value 
       else
          echo $filekey $it $value 
       fi
    fi
  done
}
iter_src_matches_only_filekey_printout(){
    iter_src_matches_only_filekey 'out'
}


usage(){
    echo 'usage: checksum-diff.sh [OPTION] <src_dir> <match_dir>'
    echo 'OPTION:'
    echo '  --file-key          -- file name as the key vs. checksums'
    echo '  --list-src          -- print out the src hash'
    echo '  --list-match        -- print out the match hash'
    echo '  --diff              -- print out only the diff items from src_dir'
    echo '  --                  -- print out only the matches items of both'
    echo '  --out               -- print out only the duplicate items'
    echo '                      -- no option, print out all items from the src_dir vs. match_dir'
    exit 0
}

file_key_opt=
src_dir=
match_dir=
list_src_opt=
list_match_opt=
diff_opt=
matching_opt=
out_opt=
for opt in $@;do
  if [[ $opt = '--file-key' ]];then
    file_key_opt=$opt
  elif [[ $opt = '--list-src' ]];then
    list_src_opt=$opt
  elif [[ $opt = '--list-match' ]];then
    list_match_opt=$opt
  elif [[ $opt = '--diff' ]];then
    diff_opt=$opt
  elif [[ $opt = '--' ]];then
    matching_opt=$opt
  elif [[ $opt = '--out' ]];then
    out_opt=$opt
    matching_opt='--'
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

if [ $list_src_opt ];then
  if [ $file_key_opt ];then
     build_src_hash_filekey
  else
    build_src_hash
  fi

  printout_src_hash
elif [ $list_match_opt ];then
  if [ $file_key_opt ];then
     build_match_hash_filekey
  else
    build_match_hash
  fi

  printout_match_hash
else 
#   build_src_hash
  if [ $file_key_opt ];then
    build_match_hash_filekey
  else
    build_match_hash
  fi

  if [ $diff_opt ];then
    # find_src_diff_only
    if [ $file_key_opt ];then
      iter_src_diff_only_filekey
    else
      iter_src_diff_only
    fi

  elif [ $matching_opt ];then
    # find_src_matches_only
    if [ $file_key_opt ];then
      if [ $out_opt ];then
        iter_src_matches_only_filekey_printout
      else
        iter_src_matches_only_filekey
      fi
    else
      if [ $out_opt ];then
        iter_src_matches_only_printout
      else
        iter_src_matches_only
      fi
      
    fi
  else 
    # find_src_diff_for_all
    if [ $file_key_opt ];then
      iter_src_diff_for_all_filekey
    else
      iter_src_diff_for_all
    fi
  fi
fi


