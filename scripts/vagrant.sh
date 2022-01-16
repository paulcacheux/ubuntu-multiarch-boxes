#!/bin/bash -x

# Create the vagrant user account.
/usr/sbin/useradd vagrant

# Enable exit/failure on error.
set -eux

printf "vagrant\nvagrant\n" | passwd vagrant
cat <<-EOF > /etc/sudoers.d/vagrant
Defaults:vagrant !fqdn
Defaults:vagrant !requiretty
vagrant ALL=(ALL) NOPASSWD: ALL
EOF
chmod 0440 /etc/sudoers.d/vagrant

# Create the vagrant user ssh directory.
mkdir -pm 700 /home/vagrant/.ssh

# Create an authorized keys file and insert the insecure public vagrant key.
curl https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys

# Ensure the permissions are set correct to avoid OpenSSH complaints.
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Mark the vagrant box build time.
date --utc > /etc/vagrant_box_build_time
