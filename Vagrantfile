# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-18.04"

  config.vm.hostname = "bcbio-docker"

  config.vm.provider "virtualbox" do |vb|
    vb.name = config.vm.hostname
    vb.memory = 4096
    vb.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    set -x
    /usr/bin/apt-get -qq update
    /usr/bin/apt-get install -qq -y docker.io
    /usr/bin/apt-get -y autoremove
    /usr/bin/apt-get clean

    /bin/systemctl start docker.service
    /usr/sbin/usermod -aG docker vagrant
  SHELL

end
