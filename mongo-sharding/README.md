# pymongo-api

## Как запустить приложение

```shell
docker compose up -d
```

## Проверка

### Проверка в браузере

http://localhost:8080/docs

### Проверка общего кол-ва документов

```shell
docker compose exec -T mongos-router mongosh --port 27016 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
```

### Проверка кол-во документов на каждом шарде

```shell
docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
```

```shell
docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
```

## Как остановить приложение

```shell
docker compose down -v
```
