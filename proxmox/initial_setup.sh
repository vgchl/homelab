#!/bin/bash

set -ex

config_host="http://10.0.10.111:9998"

lvcreate -i 1 -l 100%FREE -n data -T homelab-vg
usermod -aG sudo homelab

echo "$HOSTNAME" > /etc/hostname

mkdir -p /home/homelab/.ssh
curl -fsS -o /home/homelab/.ssh/authorized_keys "${config_host}/config/ssh_authorized_keys"
chown -R homelab /home/homelab/.ssh

echo "IP=:::::${INTERFACE_PRIMARY}:dhcp" >> /etc/initramfs-tools/initramfs.conf
curl -fsS -o /usr/share/initramfs-tools/hooks/curl "${config_host}/config/initramfs_curl.sh"
chmod 755 /usr/share/initramfs-tools/hooks/curl

/sbin/update-initramfs -u -k "all"

echo "$DEV_ROOT_PASSWORD" | /bin/clevis luks bind -y -k - -d "$DEV_ROOT" sss "$DEV_ROOT_SSS"
