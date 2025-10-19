# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "debian/bullseye64"

    #Creación servidor 
    config.vm.define "server" do |server|
    server.vm.hostname = "server"
    #Adaptador 1: Red privada
    server.vm.network "private_network", 
                      ip: "192.168.56.10"
    #Adaptador 2: Red interna (DHCP)
    server.vm.network "private_network", 
                      ip: "192.168.57.10", 
                      virtualbox__intnet: "intNet1",
                      auto_config: true
    #Provision con ansible
    server.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml"
      ansible.inventory_path = "inventory.yml"
    end
  end


  #Cliente 1
  config.vm.define "c1" do |c1|
    c1.vm.hostname = "c1"
    c1.vm.network "private_network",
                  virtualbox__intnet: "intNet1",
                  type: "dhcp"
    c1.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml"
      ansible.inventory_path = "inventory.yml"
    end
  end

  #Cliente 2
  config.vm.define "c2" do |c2|
    c2.vm.hostname = "c2"
    c2.vm.network "private_network",
                  mac: "080027AABBCC",
                  virtualbox__intnet: "intNet1",
                  type: "dhcp"
    c2.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml"
      ansible.inventory_path = "inventory.yml"
    end
  end
end
