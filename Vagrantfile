# Defines our Vagrant environment
#
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # create mgmt node
  config.vm.define :mgmt do |mgmt_config|
      mgmt_config.vm.box = "bento/ubuntu-16.04"
      mgmt_config.vm.hostname = "mgmt"
      mgmt_config.vm.network :private_network, ip: "10.0.15.10"
      mgmt_config.vm.network "forwarded_port", guest: 80, host: 80
      for i in 2368..2380
        mgmt_config.vm.network :forwarded_port, guest: i, host: i
      end
      mgmt_config.vm.provider "virtualbox" do |vb|
        vb.cpus = 2
        vb.memory = "4096"
      end
      mgmt_config.vm.provision :shell, path: "bootstrap-mgmt.sh"
  end
end
