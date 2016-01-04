# -*- mode: ruby -*-
# vi: set ft=ruby :

# bootstrap ansible roles from this repository
roles_git = "https://github.com/fdemmer/ansible_roles.git"
roles_path = "/home/vagrant/.ansible/roles"

# ansible_local provisioner required
Vagrant.require_version ">= 1.8.0"



$bootstrap_script = <<SCRIPT
apt-get update && apt-get -y install git
if [ ! -d \"#{roles_path}\" ] ; then
    sudo -u vagrant git clone #{roles_git} #{roles_path}
else
    cd #{roles_path} && git pull
fi
SCRIPT

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"

  # config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "private_network", ip: "10.10.10.10"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
  end

  config.vm.provision "bootstrap", type: "shell", inline: $bootstrap_script

  config.vm.provision "ansible", type: "ansible_local" do |ansible|
    ansible.playbook = "provisioning/site.yml"
    ansible.inventory_path = "provisioning/inventory"
  end

end
