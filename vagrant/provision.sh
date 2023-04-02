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

sudo iptables -t nat -A PREROUTING -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600
sudo iptables -t nat -A PREROUTING -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600
sudo iptables -t nat -A OUTPUT -d 127.0.0.53 -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600
sudo iptables -t nat -A OUTPUT -d 127.0.0.53 -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600