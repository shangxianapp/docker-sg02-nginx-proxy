#!/bin/bash

cd $DOCKER_NGINX_DIR
ls -lh
docker-compose up -d --force-recreate