# DNS Stack

A docker compose stack for the locally hosted DNS infrastructure. 
Designed to support resolution for LAN clients as well a resolution for overlay networks. 

## Overview

| Container | IP Address | Purpose |
| :--- | :--- | :--- |
| pdns_auth_local | 172.18.198.2 | Authoritive DNS Resolutiong for LAN |
| pdns_auth_overlay | 172.18.198.3 | Authoritive DNS Resolution for Overlay Network |
| adguardhome_local | 172.18.198.4 | External DNS Resolution for LAN, directs to pdns_auth_local |
| adguardhome_overlay | 172.18.198.5 | External DNS Resolution for the overlay networks, directs to pdns_auth_overlay | 

## Dynamic Variable Execution

`/etc/systemd/system/dns-stack-docker-compose.service`

```
[Unit]
Description=DNS Stack Docker Compose Service
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=5
WorkingDirectory=/opt/containers/stacks/dns-stack
ExecStart=/opt/containers/stacks/dns-stack/dns-stack-up.sh
ExecStop=/usr/local/bin/docker-compose down

[Install]
WantedBy=multi-user.target
```


