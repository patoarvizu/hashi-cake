#!/bin/bash

(
cat <<-EOF
bootstrap_expect = 3
retry_join = [
  "192.168.56.78",
  "192.168.56.79",
  "192.168.56.80",
]
EOF
) | sudo tee /etc/consul.d/join.hcl

sudo systemctl enable consul.service
sudo systemctl start consul

sleep 10

(
  cat <<-EOF
server {
  bootstrap_expect = 3
}
EOF
) | sudo tee /etc/nomad.d/bootstrap.hcl

sudo systemctl enable nomad.service
sudo systemctl start nomad