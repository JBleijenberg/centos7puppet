####Prerequisites:<br/>
- Install Virtualbox (https://www.virtualbox.org)<br/>
- Install Vagrant (https://www.vagrantup.com)<br/>
- Install Hosts updates: ```$ vagrant plugin install vagrant-hostsupdater```

#### Add vagrant box to your system
``` $ vagrant box add centos7puppet https://www.dropbox.com/s/vfxoqlxads9ct28/centos7puppet.box?dl=1 ```

####Edit your .Vagrantfile:<br/>
Example settings:

```
settings = {
  :hostname => "example.com",
  :domain => "example.com",
  :box => "centos7puppet",
  :ip => "192.168.33.10",
  :puppet_options => "--debug",
}
```

You can leave :puppet_options empty if you don't want to see debug information (which you probably don't)
You can add vhosts, classes and databases in ```puppet/hieradata/default.yaml```