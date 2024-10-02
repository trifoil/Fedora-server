#!/bin/bash

cd "$(dirname "$0")"

echo "The script will now install gitbucket"
echo "Updating ... "
dnf update -y

prompt() {
  local prompt_message=$1
  local default_value=$2
  read -p "$prompt_message [$default_value]: " input
  echo "${input:-$default_value}"
}



cat <<EOF > docker-compose.yaml
services:
    main-gitbucket:
      image: pgollor/gitbucket:latest
      mem_limit: 2g
      restart: always
      depends_on:
        mysql-gitbucket:
          condition: service_healthy
      environment:
        - GITBUCKET_USER_ID=${GITBUCKET_USER_ID:-9000}
        - GITBUCKET_DATABASE_HOST=database
        - GITBUCKET_DATABASE_NAME=${GITBUCKET_DATABASE_NAME}
        - GITBUCKET_DATABASE_USER=${GITBUCKET_DATABASE_USER}
        - GITBUCKET_DATABASE_PASSWORD=${GITBUCKET_DATABASE_PASSWORD}
        - GITBUCKET_MAX_FILE_SIZE=${GITBUCKET_MAX_FILE_SIZE:-10485760}
        - TZ=${TZ}
      volumes:
        - ./data/repositories/:/srv/gitbucket/repositories/
        - ./data/data/:/srv/gitbucket/data/
        - ./data/gist/:/srv/gitbucket/gist/
        - ./data/plugins/:/srv/gitbucket/plugins/
        - ./data/backup/:/srv/gitbucket/backup/
        - ./data/conf/gitbucket/gitbucket.conf:/srv/gitbucket/gitbucket.conf
        - ./data/conf/backup.conf:/srv/gitbucket/backup.conf
      tmpfs:
        - /tmp
      ports:
        - "${GITBUCKET_WEB_BIND:-127.0.0.1}:${GITBUCKET_WEB_PORT:-8080}:8080"
        - "${GITBUCKET_SSH_BIND:-127.0.0.1}:${GITBUCKET_SSH_PORT:-29418}:29418"
      links:
        - mysql-gitbucket:database

    mysql-gitbucket:
      image: mariadb:10.3
      mem_limit: 1g
      restart: always
      command: mysqld --skip-name-resolve --skip-host-cache --log-warnings=0
      healthcheck:
        test: ["CMD", "mysqladmin", "-u$GITBUCKET_DATABASE_USER", "-p$GITBUCKET_DATABASE_PASSWORD",  "ping", "-h", "localhost"]
        interval: 30s
        timeout: 30s
        retries: 10
      environment:
        - MYSQL_ROOT_PASSWORD=${GITBUCKET_DATABASE_ROOT}
        - MYSQL_DATABASE=${GITBUCKET_DATABASE_NAME}
        - MYSQL_USER=${GITBUCKET_DATABASE_USER}
        - MYSQL_PASSWORD=${GITBUCKET_DATABASE_PASSWORD}
      volumes:
        - mysql-vol-1:/var/lib/mysql/
        - ./data/conf/mysql:/etc/mysql/conf.d/:ro

volumes:
  mysql-vol-1:

EOF

echo "The docker-compose.yaml has been created successfully."

docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."