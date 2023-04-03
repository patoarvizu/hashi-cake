#!/bin/bash

sudo apt update
sudo apt install unzip curl vim -y

echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
sudo apt install apt-transport-https ca-certificates software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce
sudo usermod -aG docker vagrant

curl -sSL -o cni-plugins.tgz https://github.com/containernetworking/plugins/releases/download/v0.8.6/cni-plugins-linux-amd64-v1.2.0.tgz
sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz

cd /tmp/
NOMAD_VERSION=1.5.0
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip
unzip nomad.zip
sudo install nomad /usr/bin/nomad
sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d
(
cat <<-EOF
data_dir = "/opt/nomad"
server {
  enabled = true
}
advertise {
  http = "{{ GetInterfaceIP \\"eth1\\" }}"
  rpc = "{{ GetInterfaceIP \\"eth1\\" }}"
  serf = "{{ GetInterfaceIP \\"eth1\\" }}"
}
client {
  enabled = true
  network_interface = "eth1"
}
plugin "raw_exec" {
  config {
    enabled = true
  }
}
EOF
) | sudo tee /etc/nomad.d/server.hcl
(
cat <<-EOF
  [Unit]
  Requires=network-online.target

  [Service]
  Restart=on-failure
  ExecStart=/usr/bin/nomad agent -config=/etc/nomad.d/server.hcl -config=/etc/nomad.d/bootstrap.hcl
  ExecReload=/bin/kill -HUP \$MAINPID

  [Install]
  WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/nomad.service

CONSUL_VERSION=1.15.1
curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -o consul.zip
unzip /tmp/consul.zip
sudo install consul /usr/bin/consul
sudo mkdir -p /etc/consul.d
sudo chmod a+w /etc/consul.d
(
cat <<-EOF
bind_addr = "{{ GetInterfaceIP \\"eth1\\" }}"
client_addr = "0.0.0.0"
ui_config {
  enabled = true
}
data_dir = "/opt/consul"
server = true
connect {
  enabled = true
}
recursors = ["8.8.8.8", "8.8.4.4"]
EOF
) | sudo tee /etc/consul.d/config.hcl
(
cat <<-EOF
  [Unit]
  Requires=network-online.target

  [Service]
  Restart=on-failure
  ExecStart=/usr/bin/consul agent -config-file=/etc/consul.d/config.hcl -config-file=/etc/consul.d/join.hcl
  ExecReload=/bin/kill -HUP \$MAINPID

  [Install]
  WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/consul.service