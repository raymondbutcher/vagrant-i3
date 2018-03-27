#!/usr/bin/env bash
set -xe

export DEBIAN_FRONTEND=noninteractive

# Repo for i3
if ! dpkg -l sur5r-keyring > /dev/null ; then
    /usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2018.01.30_all.deb sur5r-keyring.deb SHA256:baa43dbbd7232ea2b5444cae238d53bebb9d34601cc000e82f11111b1889078a
    sudo dpkg -i ./sur5r-keyring.deb
    rm ./sur5r-keyring.deb
fi
if ! test -e /etc/apt/sources.list.d/sur5r-i3.list ; then
    source /etc/lsb-release
    sudo sh -c "echo \"deb http://debian.sur5r.net/i3/ $DISTRIB_CODENAME universe\" > /etc/apt/sources.list.d/sur5r-i3.list"
fi

# Repo for vscode
if ! test -e /etc/apt/trusted.gpg.d/microsoft.gpg ; then
    curl -sS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
fi
if ! test -e /etc/apt/sources.list.d/vscode.list ; then
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
fi

# System packages
apt_install="
code
i3
libgtk2.0-0
fonts-font-awesome
lightdm
linux-headers-$(uname -r)
openvpn
python-pip
python3-pip
rxvt-unicode
tig
unzip
virtualenv
xorg
"
apt_remove="
xterm
"
sudo apt-get update
sudo apt-get install -y $apt_install
sudo apt-get remove -y $apt_remove

# Python packages
pip3_install="
awscli
fontawesome
i3ipc
"
sudo -H pip2 install --upgrade pip
sudo -H pip3 install --upgrade pip
sudo -H pip3 install $pip3_install

# Direnv
if ! test -e /usr/bin/direnv ; then
    sudo wget -nv https://github.com/direnv/direnv/releases/download/v2.15.2/direnv.linux-amd64 -O /usr/bin/direnv
    sudo chmod a+x /usr/bin/direnv
fi

# asdf version manager
if ! test -d ~/.asdf ; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.3
fi
if ! grep asdf.sh ~/.bashrc > /dev/null ; then
    echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
fi
if ! grep asdf.bash ~/.bashrc > /dev/null ; then
    echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
fi
if ! test -e ~/.asdf/plugins/packer ; then
    ~/.asdf/bin/asdf plugin-add packer https://github.com/Banno/asdf-hashicorp.git
fi
if ! test -e ~/.asdf/plugins/terraform ; then
    ~/.asdf/bin/asdf plugin-add terraform https://github.com/Banno/asdf-hashicorp.git
fi

# Log in automatically
sudo rsync -ru ./lightdm /etc/
sudo systemctl enable lightdm
sudo systemctl start lightdm

# Install dotfiles
sudo rsync -ru ./profile.d /etc/
make vagrant-i3 --no-print-directory --directory=~/dotfiles
make vagrant-i3 --no-print-directory --directory=~/dotfiles-secret

# Virtualbox Guest Additions
if ! modinfo vboxsf | grep 5.2.8 > /dev/null ; then
    if ! test -e /tmp/VBoxGuestAdditions_5.2.8.iso ; then
        wget -nv -P /tmp https://download.virtualbox.org/virtualbox/5.2.8/VBoxGuestAdditions_5.2.8.iso
    fi
    sudo mkdir -p /mnt/vbguest
    if ! mount | grep /mnt/vbguest > /dev/null ; then
        sudo mount /tmp/VBoxGuestAdditions_5.2.8.iso /mnt/vbguest
    fi
    sudo /mnt/vbguest/VBoxLinuxAdditions.run || true
    if ! modinfo vboxsf | grep 5.2.8 > /dev/null ; then
        echo "VBoxLinuxAdditions.run failed"
        exit 1
    fi
    find /run/user/$(id -u) -wholename '*/i3/ipc-socket.*' -exec i3-msg -s {} exec sudo VBoxClient-all \;
    sudo umount /mnt/vbguest
    rm /tmp/VBoxGuestAdditions_5.2.8.iso
fi

echo "All done!"
