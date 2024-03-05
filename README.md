# Server installation for noobie

The script gets all my useful files and sets up the tools

first, run 

```
wget https://github.com/trifoil/Fedora-server/blob/main/setup.sh
chmod +x setup.sh
sudo ./setup.sh
```


## Cockpit setup

install and enable cockpit

```
sudo dnf install cockpit
sudo systemctl enable --now cockpit.socket
```

open firewall for cockpit

```
sudo firewall-cmd --permanent --zone=public --add-service=cockpit
sudo firewall-cmd --reload
```

default port is 9090 on localhost (and local IP)

## Docker usage

to update system, install and start docker, run 

```
sudo dnf update
sudo dnf install docker
sudo systemctl start docker
```

make docker start auto at boot

```
sudo systemctl enable docker
```

to not need to put sudo 

```
sudo usermod -aG docker $USER
```

to display docker version

```
docker --version
```

to make the docker image, run

```
docker build -t webtest .
```

to run the docker image, run

```
docker run -d -p 8080:80 webtest
```

## List open ports on Fedora

```
sudo firewall-cmd --list-ports
```

## NGINX

install nginx

```
sudo dnf install nginx
```

then in the config file opened with

```
sudo mkdir /etc/nginx/sites-available
sudo nano /etc/nginx/sites-available/my-website
```

put this, replacing the example.com by your domain name

```
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

create this directory

```
sudo mkdir /etc/nginx/sites-enabled
```

symbolic link creation 

```
sudo ln -s /etc/nginx/sites-available/my-website /etc/nginx/sites-enabled/
```

check if the nginx syntax is correct

```
sudo nginx -t
```

the answer should be

```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

once you're sure it's alright, reload nginx

```
sudo systemctl reload nginx
```

## Clounds or other

Add a A record for the doimain that points towards the ip address of the server

## Open http port 

```
sudo firewall-cmd --add-service=http --permanent
```