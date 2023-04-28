#!/bin/bash

check_all_containers_healthy() {
  output="$(docker-compose ps)"
  services="$(docker-compose config --services)"
  all_healthy=true

  for service in $services; do
    is_healthy=$(docker-compose ps | grep ${service} | grep healthy)
    # echo $service
    # echo $is_healthy
    if [ -z "$is_healthy" ]; then
      return 1
    fi
  done

  return 0
}

echo "starting green api"
docker-compose up -d api_green

while ! check_all_containers_healthy; do
  echo "Waiting for containers to become healthy..."
  sleep 6
done

echo "changing nginx to only green api"
cat nginx.green.conf > nginx.conf
docker compose exec swag nginx -s reload

echo "starting blue api"
docker-compose up -d api_blue

while ! check_all_containers_healthy; do
  echo "Waiting for containers to become healthy..."
  sleep 6
done

echo "changing nginx to both apis"
cat nginx.both.conf > nginx.conf
docker compose exec swag nginx -s reload

echo "All containers are healthy."
