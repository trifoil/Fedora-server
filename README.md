# Server installation for noobie

## Full setup

```
git clone https://github.com/trifoil/Fedora-server.git
cd Fedora-server
chmod +x setup.sh
sudo ./setup.sh
```

Then connect to cockpit using port 9090

Directly set up a static IP address !

Access portainer on port 9443



## Docker website nul

```
cd Downloads
git clone https://github.com/trifoil/Fedora-server.git
cd Fedora-server/first_test
docker build -t webtest .
docker run -d -p 8080:80 webtest
```

## Nginx proxy manager

https://nginxproxymanager.com/guide/#quick-setup

Email:    admin@example.com
Password: changeme


## Docker website suite

https://thriveread.com/docker-apache-httpd-with-php-fpm-and-mysql/