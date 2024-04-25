#!/bin/sh
## usage:
## config the environment in docker-compose.yml first
    # environment: 
    #   HOST: gateway.host.smallsaas.cn
    #   PORT: 7336
    #   USERNAME: root
    #   PASSWORD: root
    #   DATABASE: alliance

cd docker/tag/dicToExcel
docker-compose up --build
