#!/bin/bash
source .env

check_and_create_directory() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo "✅ Directory '$1' created."
    else
        echo "👍 Directory '$1' already exists."
    fi

    chown -R $PUID:$PGID "$1"
    echo "🔐 Permissions set for '$1'."
}

check_and_create_directory "$PATH_CONFIG/gluetun"
check_and_create_directory "$PATH_CONFIG/prowlarr"
check_and_create_directory "$PATH_CONFIG/radarr"
check_and_create_directory "$PATH_CONFIG/lidarr"
check_and_create_directory "$PATH_CONFIG/sonarr"
check_and_create_directory "$PATH_CONFIG/readarr"
check_and_create_directory "$PATH_CONFIG/bazarr"
check_and_create_directory "$PATH_CONFIG/deluge"

