Vagrant.configure("2") do |config|

  config.vm.define "centos-64-x64-vbox4210" do |v|
    v.vm.box = "centos-64-x64-vbox4210"
    v.vm.hostname = "centos"
    v.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
    config.vm.network "forwarded_port", guest: 80, host: 8081
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "256"]
  end

  config.vm.provision :shell, :path => "vagrant/shell/bootstrap.sh"

end
