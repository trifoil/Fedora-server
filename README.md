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


