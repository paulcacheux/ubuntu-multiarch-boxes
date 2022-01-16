#!/bin/bash -ex

printf "Installing the QEMU Tools.\n"

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

apt-get --assume-yes install qemu-guest-agent

systemctl disable open-vm-tools.service
