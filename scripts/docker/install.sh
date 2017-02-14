#!/usr/bin/env bash
set -e

echo "Installing Docker"
sudo apt-get --yes --force-yes update
sudo apt-get --yes --force-yes install apt-transport-https ca-certificates
sudo apt-key adv \
  --keyserver hkp://ha.pool.sks-keyservers.net:80 \
  --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get --yes --force-yes update
sudo apt-get --yes --force-yes install linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get --yes --force-yes update
sudo apt-get --yes --force-yes install docker-engine
sudo service docker start
