#!/bin/bash

cd $DOCKER_NGINX_DIR
ls -lh
ls -lh $DOCKER_NGINX_VHOST_DIR
docker-compose up -d --force-recreate