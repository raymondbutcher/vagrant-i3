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
python3-pip
rxvt-unicode
virtualbox-guest-dkms
virtualbox-guest-x11
xorg
"
apt_remove="
xterm
"
sudo apt-get update
sudo apt-get install -y $apt_install
sudo apt-get remove -y $apt_remove

# Python 3 packages
pip3_install="
fontawesome
i3ipc
"
sudo -H pip3 install --upgrade pip
sudo -H pip3 install $pip3_install

# Log in automatically
sudo rsync -ru ./lightdm /etc/
sudo systemctl enable lightdm
sudo systemctl start lightdm

# Install dotfiles
make vagrant-i3 --no-print-directory --directory=~/dotfiles
make vagrant-i3 --no-print-directory --directory=~/dotfiles-secret
