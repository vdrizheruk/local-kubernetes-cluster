Vagrant.configure("2") do |config|
    # Configure the box to use
    config.vm.box       = 'ubuntu/xenial64'

    # Configure the network interfaces
    config.vm.network :private_network, ip:    "192.168.33.200"

    # Configure VirtualBox environment
    config.vm.provider :virtualbox do |v|
        v.name = (0...8).map { (65 + rand(26)).chr }.join
        v.customize [ "modifyvm", :id, "--memory", 4096 ]
    end

   # Install Python
   config.vm.provision "shell", inline: <<-SHELL
     apt-get update
     apt-get install -y python
   SHELL

    # Provision the box
    config.vm.provision :ansible do |ansible|
        ansible.extra_vars = { ansible_ssh_user: 'ubuntu' }
        ansible.playbook = "ansible/kubernetes-master.yml"
    end
end
