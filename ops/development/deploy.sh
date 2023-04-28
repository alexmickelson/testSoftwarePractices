#!/bin/bash

check_all_containers_healthy() {
  services="$(docker-compose config --services)"
  all_healthy=true

  for service in $services; do
    is_healthy=$( docker-compose ps | grep ${service} | grep \(healthy )
    if [ -z "$is_healthy" ]; then
      return 1
    fi
  done
  return 0
}

echo "changing nginx to only blue web"
cat nginx.blue.conf > nginx.conf
docker compose exec reverse_proxy nginx -s reload

echo "starting green web"
docker-compose up -d web_green

while ! check_all_containers_healthy; do
  echo "Waiting for containers to become healthy..."
  sleep 6
done

echo "changing nginx to only green web"
cat nginx.green.conf > nginx.conf
docker compose exec reverse_proxy nginx -s reload

echo "starting blue web"
docker-compose up -d web_blue

while ! check_all_containers_healthy; do
  echo "Waiting for containers to become healthy..."
  sleep 6
done

echo "changing nginx to both webs"
cat nginx.both.conf > nginx.conf
docker compose exec reverse_proxy nginx -s reload

while ! check_all_containers_healthy; do
  echo "Waiting for containers to become healthy..."
  sleep 6
done

echo "All containers are healthy."