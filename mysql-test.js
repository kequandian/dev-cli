#!/usr/bin/env node

var program = require('commander');
const axios = require('axios')
const yaml = require('js-yaml')
var fs = require('fs');
var path = require(`path`)

program
    .command('get-connection-string [format]')
    .action(function (format) {
      let yml = './src/main/resources/application.yml'
      if (!fs.existsSync(yml)) {
          console.log('application.yml not exists, not an maven project !')
          return
      }

      // get project 
      var active_datasource = {}
      
      var active_classifier = 'dev'
      const data = fs.readFileSync(yml, {encoding:'utf8', flag:'r'})
      yaml.loadAll(data, function (doc) {
        if(doc==undefined){
            // skip null doc
        }else if(doc==undefined||doc.spring===undefined||doc.spring.profiles===undefined||doc.spring.profiles.active===undefined){
            // profiles
            if(doc!=undefined && doc.spring!=undefined && doc.spring.profiles==active_classifier){
              let datasource  = doc.spring.datasource
              active_datasource['url'] = datasource.url
              active_datasource['username'] = datasource.username
              active_datasource['password'] = datasource.password
            }
        }else{
          classifier = doc.spring.profiles.active
        }
      });

      if (format == 'json'){
         console.log(active_datasource);
      }else{
         let cstring  = `${active_datasource.url}&user=${active_datasource.username}&password=${active_datasource.password}`
        //  console.log(cstring.replaceAll("&", "\\&"));
        console.log(cstring);
      }
    });

program.parse(process.argv);
