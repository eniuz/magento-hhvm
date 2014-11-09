# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.network :forwarded_port, guest: 8000, host: 8100
    config.vm.network :private_network, ip: "192.168.66.67"
    config.vm.hostname = "magento.hhvm.local"

    config.vm.provider :virtualbox do |vb|
        vb.name = "MagentoHHVM"
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
    end

    # Shared folders
    require 'ffi'
    mount_options = ["dmode=777", "fmode=777"]
    opts = if FFI::Platform::IS_WINDOWS
        { :mount_options => mount_options }
    else
        { :nfs => mount_options }
    end

    config.vm.synced_folder(".", "/vagrant", opts)

    # Provision
    config.vm.provision :shell, :path => "build/build_vm.sh"
end
