# Docker

# Домашнее задание

Docker, docker-compose, dockerfile
Цель:

Разобраться с основами docker, с образа, эко системой docker в целом.

Описание ДЗ в документе

# Команды
```bash
docker pull mariadb
docker images
docker run -p 127.0.0.1:3306:3306  --name mariadb -e MARIADB_ROOT_PASSWORD=superpass -d mariadb
docker ps
docker run --name adminer --link mariadb:db -p 8080:8080 -d adminer
http://127.0.0.1:8080/
docker exec -ti adminer sh
cat /etc/hosts
docker stop
docker rm
docker rmi
```

