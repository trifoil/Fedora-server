# Fedora-server

Homelab install tailored for personal use, under fedora, but most probably compatible with a lot of distros

## Quick start

```
rm -rf Fedora-server
git clone https://github.com/trifoil/Fedora-server.git
cd Fedora-server
sudo sh main.sh
cd ..
clear
```

## What's included :

Installed from the script and ```required``` for the other services : 

* Docker (install it through this script, that follows the official way)

Admin services :

- [x] Portainer
- [x]  Nginx Proxy Manager
- [x]  DDNS updater
- [ ] Uptime-kuma
- [x]  FileBrowser
- [ ] OpenVPN

User services :

- [x]  Nextcloud AIO
- [x]  Jellyfin
- [x]  Deluge
- [ ]  Gitbucket

## Sources

* https://github.com/louislam/uptime-kuma
* https://github.com/pgollor/gitbucket-docker/tree/master
* https://github.com/qdm12/ddns-updater/blob/master/docker-compose.yml
* https://github.com/element-hq/synapse/blob/develop/contrib/docker/docker-compose.yml
* https://github.com/OpenVPN/as-docker
* https://github.com/pgollor/gitbucket-docker/blob/master/docker-compose.yml
* https://ocserv.openconnect-vpn.net/packages

