```
version: "3.7"
services:
  ddns-updater:
    image: qmcgaw/ddns-updater
    container_name: ddns-updater
    network_mode: bridge
    ports:
      - 8000:8000/tcp
    volumes:
      - ./data:/updater/data
    environment:
      -  CONFIG={"settings":[{"provider":"strato","domain":"mydomain","host":"test,cloud","password":"mypassword"}]}
      -  PERIOD=5m
      -  IP_METHOD=cycle
      -  IPV4_METHOD=cycle
      -  IPV6_METHOD=cycle
      -  HTTP_TIMEOUT=10s
      -  LISTENING_PORT=8000
      -  ROOT_URL=/
    restart: always

```

```
{
    "settings": [
        {
            "provider": "strato.de",
            "domain": "my.domain",
            "host": "cloud,test",
            "password": "Mypassword"
        }
    ]
}
```