## How to get script root path
```shell
bin_root=()
os_name=$(uname)
if [[ $os_name == 'Darwin' ]];then
   bin_root=$(greadlink -f "$0")
else 
   bin_root=$(readlink -f "$0")
fi
```
