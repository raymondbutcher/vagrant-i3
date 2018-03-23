Vagrant.configure("2") do |config|

    config.vm.provider "virtualbox" do |vb|
        vb.name = "CentOS"
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

    config.vm.box = "JLofgren/centos7-i3wm"
    config.vm.box_version = "0.0.1"
    config.vm.box_check_update = false

    config.vm.provision "file", source: "~/dotfiles", destination: "/tmp/dotfiles"
    config.vm.provision "file", source: "~/dotfiles-secret", destination: "/tmp/dotfiles-secret"
    config.vm.provision "file", source: "./config", destination: "/tmp/config"
    config.vm.provision "shell", privileged: false, inline: "cd /tmp/config && bash provision.sh"

end
