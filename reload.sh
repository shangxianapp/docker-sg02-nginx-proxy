#!/bin/bash

cd $DOCKER_NGINX_DIR
ls -lh
ls -lh $DOCKER_NGINX_VHOST_DIR
docker exec ${DOCKER_NGINX_CONTAINER_NAME} nginx -t && docker-compose up -d --force-recreate
