# Server installation for noobie

## Initial setup

The script gets all my useful files and sets up the tools

first, run 

```
curl -O https://raw.githubusercontent.com/trifoil/Fedora-server/main/setup.sh
chmod +x setup.sh
sudo ./setup.sh
```

Then connect to cockpit using port 9090

Directly set up a static IP address !

Access portainer on port 9443



## Docker compose to generate website

```
cd Downloads
git clone https://github.com/trifoil/Fedora-server.git
cd Fedora-server/second_test
docker compose up -d
```

## Nginx proxy manager

https://nginxproxymanager.com/guide/#quick-setup