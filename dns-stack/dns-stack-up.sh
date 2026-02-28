#!/bin/bash

IP_OVERLAY=$(ip -br a | grep "tailscale0 " | awk '{print $3}' | cut -d '/' -f 1)
IP_LAN=$(ip -br a | grep "eth0 " | awk '{print $3}' | cut -d '/' -f 1)
export IP_OVERLAY IP_LAN
/usr/bin/docker compose up -d

