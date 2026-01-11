#!/bin/bash
set -e

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl docker.io

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker ubuntu

# docker compose v2 plugin
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
