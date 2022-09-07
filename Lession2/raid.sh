#!/bin/bash

sudo yum install -y mdadm
sudo mdadm --create /dev/md0 --level=10 --raid-devices=10 /dev/sd[b-k]

mkdir /etc/mdadm
sudo echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf

parted -s /dev/md0 mklabel gpt
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 20% 40%
parted /dev/md0 mkpart primary ext4 40% 60%
parted /dev/md0 mkpart primary ext4 60% 80%
parted /dev/md0 mkpart primary ext4 80% 100%


mkfs.ext4 /dev/md0p1
mkfs.ext4 /dev/md0p2
mkfs.ext4 /dev/md0p3
mkfs.ext4 /dev/md0p4
mkfs.ext4 /dev/md0p5

mkdir /mnt/md0
mkdir /mnt/md0/part1
mkdir /mnt/md0/part2
mkdir /mnt/md0/part3
mkdir /mnt/md0/part4
mkdir /mnt/md0/part5

mount /dev/md0p1 /mnt/md0/part1
mount /dev/md0p2 /mnt/md0/part2
mount /dev/md0p3 /mnt/md0/part3
mount /dev/md0p4 /mnt/md0/part4
mount /dev/md0p5 /mnt/md0/part5

echo "/dev/md0p1 /mnt/md0/part1 ext4 defaults 0 0" >> /etc/fstab
echo "/dev/md0p2 /mnt/md0/part2 ext4 defaults 0 0" >> /etc/fstab
echo "/dev/md0p3 /mnt/md0/part3 ext4 defaults 0 0" >> /etc/fstab
echo "/dev/md0p4 /mnt/md0/part4 ext4 defaults 0 0" >> /etc/fstab
echo "/dev/md0p5 /mnt/md0/part5 ext4 defaults 0 0" >> /etc/fstab