#!/usr/bin/env bash
set -e

echo "Adding apt-repository"
source /etc/lsb-release && echo "deb http://download.rethinkdb.com/apt $DISTRIB_CODENAME main" | sudo tee /etc/apt/sources.list.d/rethinkdb.list
wget -qO- https://download.rethinkdb.com/apt/pubkey.gpg | sudo apt-key add -

echo "apt-get updat(ing)"
sudo apt-get update

echo "Installing RethinkDB"
sudo apt-get install -y rethinkdb ntp ntpdate

echo "Configuring RethinkDB"
sudo cp /etc/rethinkdb/default.conf.sample /etc/rethinkdb/instances.d/cluster.conf
