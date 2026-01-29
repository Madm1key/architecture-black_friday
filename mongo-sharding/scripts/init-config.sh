#!/usr/bin/env bash

docker compose exec -T config-server mongosh <<EOF
rs.initiate(
  {
    _id: "config-server",
    configsvr: true,
    members: [
      { _id: 0, host: "config-server:27017" }
    ]
  }
)
EOF
