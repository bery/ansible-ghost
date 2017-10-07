#!/usr/bin/env bash

# install ansible (http://docs.ansible.com/intro_installation.html)
apt-get -y install software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get -y install ansible mc git

#ansible-galaxy install -r /vagrant/tests/requirements.yml
#ansible-playbook -i "localhost" -k /vagrant/tests/docker.yml --connection=local

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL

# vagrant environment nodes
10.0.15.10  mgmt
EOL

