#!/usr/bin/env bash
set -e

# Install simple packages
packages="htop iotop jq lsof NetworkManager-openvpn-gnome mtr socat tcpdump telnet tig traceroute unzip zip"
to_install=""
for package in $packages; do
    rpm -q $package > /dev/null || {
        to_install="$to_install $package"
    }
done
if [ "$to_install" != "" ]; then
    echo "Installing $to_install"
    sudo yum install -y $to_install
fi

# Install Git 2.x
rpm -q git | grep git-2 > /dev/null || {
    sudo rpm --import http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco
    sudo yum install -y http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
    sudo yum update -y git
}

# Install Visual Studio Code
rpm -q code > /dev/null || {
    echo "Installing vscode"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo yum install -y code
}

# Install Google Chrome
rpm -q google-chrome-stable > /dev/null || {
    echo "Installing google-chrome"
    sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub
    sudo yum install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
}

# Copy config files
echo "Copying configs"
rsync -ru ./i3 ~/.config/
sudo rsync -ru ./lightdm /etc/
rsync -ru ./lilyterm ~/.config/
rsync -ru ./ssh/ ~/.ssh/
cp .Xresources ~/

# Remove boot screen options to make it boot faster
grep GRUB_TIMEOUT=0 /etc/default/grub > /dev/null || {
    echo "Removing boot screen options"
    sudo sed -i -e '/GRUB_TIMEOUT/d' /etc/default/grub
    sudo sh -c 'echo "GRUB_TIMEOUT=0" >> /etc/default/grub'
    sudo grub2-mkconfig --output /boot/grub2/grub.cfg
}

# Reboot to apply changes
echo "Rebooting"
sudo reboot
