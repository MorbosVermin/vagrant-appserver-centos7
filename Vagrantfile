# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "home/centos7"

  # Forward Web Service Ports
  config.vm.hostname = "appserver"
  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
  config.vm.network "forwarded_port", guest: 443, host: 8443, auto_correct: true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  #config.vm.provision :puppet do |puppet|
  #	puppet.manifests_path = "puppet/manifests"
  #	puppet.module_path = "puppet/modules"
  #	puppet.manifest_file = "provision.pp"
  #	puppet.options = "--verbose --debug"
  #end

  config.vm.provision "shell", path: "provision.sh"
  
end
