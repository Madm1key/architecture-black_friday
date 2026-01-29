#!/usr/bin/env bash

docker compose exec -T mongos-router mongosh <<EOF
rs.initiate(
  {
    _id: "mongos-router",
    configsvr: true,
    members: [
      { _id: 0, host: "mongos-router:27016" }
    ]
  }
)
EOF
