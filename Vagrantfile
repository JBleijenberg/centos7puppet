# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

settings = {
  :hostname => "example.com",
  :aliases => ["www.example.com", "alias.example.com"],
  :domain => "example.com",
  :box => "centos7puppet",
  :ip => "192.168.33.10", # If not set, DHCP will be used
  :puppet_options => "--debug",
  :private_key => "~/.ssh/id_rsa"
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # Private keys
    config.ssh.private_key_path = [ '~/.vagrant.d/insecure_private_key', settings[:private_key] ]
    config.ssh.forward_agent = true

    # Box name
    config.vm.box = settings[:box]

    # Hostname
    config.vm.host_name = "#{settings[:hostname]}"

    unless Vagrant.has_plugin?("vagrant-hostsupdater")
      raise 'vagrant hostsupdated is not installed!'
    else
        if settings[:aliases]
            config.hostsupdater.aliases = settings[:aliases]
        end
    end

    # Provider box url
    config.vm.box = "#{settings[:box]}"

    # Port forwarding
    config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true

    if settings[:ip]
      config.vm.network "private_network", ip: settings[:ip]
    else
      config.vm.network "private_network", type: "dhcp"
    end

    # Shared folders
    config.vm.synced_folder "src/", "/var/www", owner: "vagrant", group: "vagrant"
    config.vm.synced_folder "puppet/hieradata/", "/etc/puppet/hieradata"

    # Puppet config
    config.vm.provision :puppet,
        :options => [settings[:puppet_options]] do |puppet|
            puppet.manifests_path = "puppet/manifests"
            puppet.manifest_file  = "site.pp"
            puppet.module_path = "puppet/modules"
    end
end
