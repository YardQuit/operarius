#!/bin/bash

set -ouex pipefail

### Copy sysfiles
# cp -rv /ctx/sysfiles/* /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# This installs a package from fedora repos
# dnf5 group install --skip-unavailable -y cosmic-desktop

dnf5 install --skip-unavailable -y $(cat /ctx/rpm_packages)

# Enable copr repositories
dnf5 -y copr enable atim/starship
dnf5 -y copr enable pennbauman/ports

# Install from copr repositories
dnf5 -y install starship
dnf5 -y install lf

# Disable copr repositories
dnf5 -y copr disable atim/starship
dnf5 -y copr disable pennbauman/ports

# Clean
dnf5 clean all

### Change default firewalld zone
cp /etc/firewalld/firewalld-workstation.conf /etc/firewalld/firewalld-workstation.conf.bak
firewall-cmd --set-default-zone=FedoraWorkstation
firewall-cmd --permanent --zone=FedoraWorkstation --add-service=ssh
firewall-cmd --permanent --zone=FedoraWorkstation --add-service=rdp
firewall-cmd --reload

#### System Unit File
systemctl enable tuned.service
systemctl enable podman.socket
systemctl enable fstrim.timer
systemctl enable tailscaled.service
systemctl enable sshd.service

 
