# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "web" do |node|
    node.vm.box = "gbarbieru/xenial"
    node.vm.network "private_network", ip: "192.168.0.3", netmask: "255.255.255.0"
    node.vm.provision "shell", inline: "sudo apt install python -y"
    node.vm.provision "ansible" do |ansible|
      ansible.playbook = "webservers.yml"
    end
  end

  config.vm.define "cache" do |node|  
    node.vm.box = "gbarbieru/xenial"
    node.vm.network "private_network", ip: "192.168.0.2", netmask: "255.255.255.0"
    node.vm.provision "shell", inline: "sudo apt install python -y"
    node.vm.provision "ansible" do |ansible|
      ansible.playbook = "varnish.yml"
    end
  end
end
