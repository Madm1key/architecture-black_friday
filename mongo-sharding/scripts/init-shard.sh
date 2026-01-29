#!/usr/bin/env bash

docker compose exec -T shard1 mongosh <<EOF
rs.initiate(
  {
    _id: "shard1",
    members: [
      { _id: 0, host: "shard1:27018" }
    ]
  }
)
EOF

docker compose exec -T shard2 mongosh <<EOF
rs.initiate(
  {
    _id: "shard2",
    members: [
      { _id: 0, host: "shard2:27019" }
    ]
  }
)
EOF
