## dev-cli
> Install all the cli tools globally
Some tiny script tools in cli maner, install all the tools as below line
```sh
$ git clone --depth=1 https://gitee.com/smallsaas/dev-cli.git
$ cd dev-cli
$ npm i
$ npm link
```



### current cli
- remote
> Used to handle multi git repo in current dir
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

- standalone
> used to run target/pack-1.0.0-standalone.jar locally 
> first change path into the mvn project and type 'standalone'

```shell
$ standalone -h

Usage: standalone [OPTIONS] [TARGET]
   TARGET :           -- classifier: --spring.profiles.active=?

   OPTIONS:
      standalone -h --help      -- print usage
      standalone -              -- force rebuild: mvn clean
      standalone .              -- ignore config
      standalone [TARGET]       -- default target: 'standalone'
      standalone -p <port>      -- server port: --server-port=?
      standalone -X [port]      -- remote debug, default port: 5005
```

- deploy-web
> Used to deploy local dist to remote server

- deploy-lib
> Used to deploy local lib jar to remote server

### Markdown famous devops tools for reference
- CoreOS
- chef
- puppet
- Marathon/Mesos
- saltstack
- Prometheus + Grafana
