# Server installation for noobie

## Full setup

```
git clone https://github.com/trifoil/Fedora-server.git
cd Fedora-server
chmod +x setup.sh
sudo ./setup.sh
```

## Manual instructions (post setup)

1) Connect to cockpit using port 9090
    * Directly set up a static IP address !

2) Access portainer on port 9443

3) Access nginx on port 81
    * Default credentials:
        * Email:    admin@example.com
        * Password: changeme

4) Access phpMyAdmin
    * Default credentials:
        * User: root as the  and 
        * Password: password

## Useful links

https://nginxproxymanager.com/guide/#quick-setup
https://thriveread.com/docker-apache-httpd-with-php-fpm-and-mysql/