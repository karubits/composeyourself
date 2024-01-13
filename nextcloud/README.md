# Nextcloud Stack

### Genearting a token

`docker compose exec -u www-data nextcloud-web php occ config:app:set serverinfo token --value homepage`