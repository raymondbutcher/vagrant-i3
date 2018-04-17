Vagrant.configure("2") do |config|

    config.vm.box = "bento/ubuntu-16.04"
    config.vm.box_check_update = false

    config.vm.provider "virtualbox" do |vb|
        vb.name = "Workstation"
        vb.cpus = 1
        vb.gui = true
        vb.memory = "4096"
        vb.customize ['modifyvm', :id, '--accelerate3d', 'on']
        vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
        vb.customize ['modifyvm', :id, '--cpus', '1']
        vb.customize ['modifyvm', :id, '--vram', '64']
        vb.customize ['modifyvm', :id, '--vrde', 'off']
        vb.customize ['setextradata', :id, 'GUI/HiDPI/UnscaledOutput', '1']
    end

    if defined? VagrantVbguest
        config.vbguest.auto_update = false
    end

    config.vm.synced_folder '.', '/vagrant', disabled: true

    copy_dirs = {
        "~/dotfiles"        => "~/dotfiles",
        "~/dotfiles-secret" => "~/dotfiles-secret",
        "./provision"       => "~/provision",
    }
    copy_dirs.each do |src, dest|
        config.vm.provision "shell", privileged: false, inline: "rm -rf /tmp/copydir"
        config.vm.provision "file", source: src, destination: "/tmp/copydir"
        config.vm.provision "shell", privileged: false, inline: "rm -rf #{dest} && mv /tmp/copydir #{dest}"
    end
    config.vm.provision "shell", privileged: false, inline: "cd provision && bash provision.sh"

end
