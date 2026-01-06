#!/bin/bash
set -e

apt-get update -y
apt-get install -y ca-certificates curl docker.io

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

# docker compose v2 plugin
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
