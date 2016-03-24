# -*- mode: ruby -*-
# vi: set ft=ruby :


# bootstrap ansible roles from this repository
roles_git = "https://github.com/fdemmer/ansible_roles.git"
roles_branch = "master"
roles_path = "/etc/ansible/roles"

# ansible_local provisioner required
Vagrant.require_version ">= 1.8.0"


def get_ipaddr(hostname, default)
  return Socket::getaddrinfo(hostname, nil)[0][3]
  rescue SocketError
    return default
end

$bootstrap_script = <<SCRIPT
# install ansible 1.9
if ! hash ansible 2>/dev/null; then
    rm /etc/apt/sources.list.d/ansible-ansible-trusty.list 2>/dev/null
    yes|add-apt-repository ppa:ansible/ansible-1.9 2>/dev/null
    apt-get update && apt-get -y install ansible
fi
# install git
if ! hash git 2>/dev/null; then
    apt-get update && apt-get -y install git
fi
# install our custom ansible roles
if [ ! -d \"#{roles_path}\" ]; then
    git clone -b #{roles_branch} #{roles_git} #{roles_path}
else
    cd #{roles_path} && git pull
fi
SCRIPT


Vagrant.configure(2) do |config|
  config.vm.hostname = "django.box"
  config.vm.box = "ubuntu/trusty64"

  config.vm.box_check_update = true
  config.ssh.forward_agent = true

  private_network_ip = get_ipaddr(config.vm.hostname, "10.10.10.10")
  config.vm.network "private_network", ip: private_network_ip
  #config.vm.network "forwarded_port", guest: 8000, host: 8000

  # Use NFS for shared folders for better performance
  # requires nfs-kernel-server:
  #     sudo apt-get install nfs-kernel-server
  config.vm.synced_folder '.', '/vagrant'#, nfs: true

  config.vm.provider "virtualbox" do |v|
    v.cpus = 2
    v.memory = "1024"
    #v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end

  config.vm.provision "bootstrap", type: "shell", inline: $bootstrap_script

  # machine name used in virtualbox name and for provisioning/inventory
  config.vm.define "default"
  config.vm.provision "ansible", type: "ansible_local" do |ansible|
    ansible.playbook = "provisioning/site.yml"
    ansible.extra_vars = "extra_vars.yml"
    ansible.raw_arguments = Shellwords.shellsplit(ENV['ANSIBLE_ARGS']) if ENV['ANSIBLE_ARGS']
    ansible.verbose = 'vvv'
  end

  config.vm.post_up_message = \
    "The private network IP address is: #{private_network_ip}\n" \
    "To customize, add a host called '#{config.vm.hostname}' to your /etc/hosts!"
end
