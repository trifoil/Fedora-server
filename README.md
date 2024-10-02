# Fedora-server

## Quick start

```
rm -rf Fedora-server
git clone https://github.com/trifoil/Fedora-server.git
cd Fedora-server
sudo sh main.sh
cd ..
clear
```

## Available in the bundle :

Installed from the script and ```required``` for the following services : 

* Docker

Admin services :

* Portainer
* Nginx Proxy Manager
* DDNS updater
* Uptime-kuma
* FileBrowser

User services :

* Nextcloud AIO
* Streaming
    * Jellyfin
    * Deluge
* Gitbucket

## Sources

* https://github.com/louislam/uptime-kuma
* https://github.com/pgollor/gitbucket-docker/tree/master
* https://github.com/qdm12/ddns-updater/blob/master/docker-compose.yml