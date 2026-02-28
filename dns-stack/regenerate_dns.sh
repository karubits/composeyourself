#!/bin/bash

# Source environment variables
source .env

# Function to configure DNS Server
configure_dns_server() {
    local CONTAINER=$1
    local IP_ADDRESS=$2

    echo -e "\n\n🔹 Now configuring $CONTAINER\n"
    
    echo "🔹 Creating zone for $DEFAULT_DOMAIN..."
    docker exec $CONTAINER pdnsutil delete-zone $DEFAULT_DOMAIN
    echo "🔹 Adding DNS Records..."
    docker exec $CONTAINER pdnsutil create-zone $DEFAULT_DOMAIN ns1.$DEFAULT_DOMAIN
    docker exec $CONTAINER pdnsutil replace-rrset $DEFAULT_DOMAIN @ SOA 3600 "ns1.$DEFAULT_DOMAIN hostmaster.$DEFAULT_DOMAIN 100 10800 3600 604800 3600"
    docker exec $CONTAINER pdnsutil add-record $DEFAULT_DOMAIN ns1 A 3600 $IP_ADDRESS
    docker exec $CONTAINER pdnsutil add-record $DEFAULT_DOMAIN . ALIAS 3600 $GITUSER.github.io
    docker exec $CONTAINER pdnsutil add-record $DEFAULT_DOMAIN *. A 3600 $IP_ADDRESS
    docker exec $CONTAINER pdnsutil increase-serial $DEFAULT_DOMAIN

    echo -e "\n🔹 Listing zone records..."
    docker exec $CONTAINER pdnsutil list-zone $DEFAULT_DOMAIN
    echo -e "\n🔹 Health Check, please confirm output."
    docker exec $CONTAINER pdnsutil check-all-zones

    echo -e "\n🔹 Configuration of $CONTAINER has been completed."
    echo -e "\n 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦"
}

# Get overlay network IP address
IP_OVERLAY=$(ip -br a | grep "tailscale0 " | awk '{print $3}' | cut -d '/' -f 1)
# Get local network IP address
IP_LAN=$(ip -br a | grep "eth0 " | awk '{print $3}' | cut -d '/' -f 1)

# Build the overlay network DNS Server
configure_dns_server "pdns_auth_overlay" $IP_OVERLAY

# Build the local network DNS Server
configure_dns_server "pdns_auth_local" $IP_LAN