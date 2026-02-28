#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [ ! -f .env ]; then
  echo "Error: .env not found. Create it from .env.example and set DEFAULT_DOMAIN, PATH_DATA, NEXTCLOUD_DATA_DIR."
  exit 1
fi
source .env

echo ""
echo "=============================================="
echo "  WARNING: NEXTCLOUD FACTORY RESET"
echo "=============================================="
echo "  ALL NEXTCLOUD DATA WILL BE PERMANENTLY WIPED."
echo "  This removes:"
echo "    - ${PATH_DATA}/nextcloud/db   (database)"
echo "    - ${PATH_DATA}/nextcloud/web  (app/config)"
echo "    - ${NEXTCLOUD_DATA_DIR}       (user data)"
echo "  This action CANNOT be undone."
echo "=============================================="
echo ""
read -p "Type 'yes' to confirm and destroy all data: " confirm
if [ "$confirm" != "yes" ]; then
  echo "Aborted."
  exit 1
fi

docker compose down
docker network rm nc_network 2>/dev/null || true

rm -rfv "${PATH_DATA}/nextcloud/db"
rm -rfv "${PATH_DATA}/nextcloud/web"
rm -rfv "${NEXTCLOUD_DATA_DIR}"

docker compose up -d
echo "Waiting for services..."
sleep 15

docker compose exec -u www-data nextcloud-web php occ config:system:set trusted_domains 0 --value=localhost
docker compose exec -u www-data nextcloud-web php occ config:system:set trusted_domains 1 --value=hub.${DEFAULT_DOMAIN}
docker compose exec -u www-data nextcloud-web php occ config:system:set trusted_domains 2 --value=nextcloud-web
docker compose exec -u www-data nextcloud-web php occ config:system:set default_phone_region --type string --value="JP"

echo "Done."
