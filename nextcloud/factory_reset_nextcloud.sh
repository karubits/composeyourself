#!/bin/bash
echo "Nuking Nextcloud!"
docker compose down
docker network rm nc_network
docker volume rm  nextcloud_db
docker volume rm  nextcloud_web
rm -rfv /mnt/data/nextcloud/*
rm -rfv /mnt/data/nextcloud/.*
docker compose up -d
#docker compose logs
ping -c 15 localhost


docker compose exec -u www-data nextcloud-web php occ config:system:set trusted_domains 0 --value=localhost
docker compose exec -u www-data nextcloud-web php occ config:system:set trusted_domains 1 --value=hub.karubits.com
docker compose exec -u www-data nextcloud-web php occ config:system:set trusted_domains 2 --value=nextcloud-web
docker compose exec -u www-data nextcloud-web php occ config:system:set default_phone_region --type string --value="JP"

