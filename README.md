# vagrant-i3

This is my Vagrant environment for development purposes. It runs CentOS 7 with the i3 tiling window manager. The goal is to have a consistent development environment across multiple host machines running macOS, Linux and Windows.

## Usage

```
vagrant plugin install vagrant-vbguest
vagrant up
```

## Todo

* shared secret files
    * keybase?
    * ssh keys
    * vpn config
    * aws credentials
    * chrome browser profiles
    * vs code user settings
* git repos
    * don't clone them automatically
    * add tool for cloning them easily
* openvpn
* work tools
    * custom work tools
    * pip
    * docker
    * aws cli
    * terraform version manager
    * packer version manager
* mac touchpad horizontal scrolling not working in vs code
