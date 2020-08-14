## dev cli
Some tiny script tools in cli maner

### current cli
> use to deploy local target/maven-build-jar.jar
>
> - deployless  

> use to git repo url freeely
- dependency

```shell
$ dependency

Usage: dependency Options [Variables...]
e.g. dependency -p ./lib/test.jar
用于Jar包依赖输出 和 Maven module依赖对比

Options:
  -c, --compare [Maven module I] [Maven module II]  对比两个Maven module依赖情况并生成JSON文件
  -p, --parse [Jar Path]  解析Jar包依赖并生成JSON文件
  -v, --version  输出当前工具版本信息
```

- remote
```shell
$ remote
Usage:
   remote <CMD> <dir> [target]
 CMD: <get|xfr|mv|fix|clone|init|push|pull|test|mirror>
   xfr <target>    -- transfer one repo to another
   mv              -- mv one repo name to new name
   fix <target>    -- fix one repo base on the dir name
   clone <target>  -- clone a repo base on the dir repo
   pull .          -- pull all the repo in current dir
   clean .          -- clean current dir base on pom.xml
   mirror <target> [mirror] -- mirror current repo into a mirror repo
   mirrorback <target> [imrror] -- mirror repo into current target
```

> use to run target/pack-1.0.0-standalone.jar locally 
> first change path into the mvn project and type 'standalone'
- standalone

## Install all the cli tools globally
```sh
$ git clone https://github.com/kequandian/dev-cli
$ cd dev-cli
$ npm i -g
```

### Markdown famous devops tools for reference
- CoreOS
- chef
- puppet
- Marathon/Mesos
- saltstack
- Prometheus + Grafana
