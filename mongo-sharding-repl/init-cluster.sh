#!/bin/bash

# Ожидание доступности портов
sleep 5

echo "--- Инициализация Config Server ---"
mongosh --host config-server --port 27017 --eval 'rs.initiate({
  _id: "config_server",
  configsvr: true,
  members: [
    {_id: 0, host: "config-server:27017"}
  ]
})'

echo "--- Инициализация Shard 1 ---"
mongosh --host shard1-1 --port 27018 --eval 'rs.initiate({
  _id: "shard1",
  members: [
    {_id: 0, host: "shard1-1:27018"},
    {_id: 1, host: "shard1-2:27018"},
    {_id: 2, host: "shard1-3:27018"}
  ]
})'

echo "--- Инициализация Shard 2 ---"
mongosh --host shard2-1 --port 27019 --eval 'rs.initiate({
  _id: "shard2",
  members: [
    {_id: 0, host: "shard2-1:27019"},
    {_id: 1, host: "shard2-2:27019"},
    {_id: 2, host: "shard2-3:27019"}
  ]
})'

sleep 5

echo "--- Подключение шардов к роутеру ---"
mongosh --host mongos-router --port 27016 --eval '
  sh.addShard("shard1/shard1-1:27018,shard1-2:27018,shard1-3:27018")
  sh.addShard("shard2/shard2-1:27019,shard2-2:27019,shard2-3:27019")
'

echo "--- Инициализация БД ---"
mongosh --host mongos-router --port 27016 --eval '
  sh.enableSharding("somedb");
  sh.shardCollection("somedb.helloDoc", { "name": "hashed" });
  var db = db.getSiblingDB("somedb");
  var docs = [];
  for(var i = 0; i < 1000; i++) {
    docs.push({age: i, name: "ly" + i});
  }
  db.helloDoc.insertMany(docs);
'
