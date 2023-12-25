#!/bin/bash

sudo -i

# install zfs repo
yum install -y http://download.zfsonlinux.org/epel/zfs-release.el7_8.noarch.rpm
# import gpg key 
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
# install DKMS style packages for correct work ZFS
yum install -y epel-release kernel-devel zfs
# change ZFS repo
yum-config-manager --disable zfs
yum-config-manager --enable zfs-kmod
yum install -y zfs
# Add kernel module zfs
modprobe zfs
yum install -y wget


zpool create m1 mirror /dev/sdb /dev/sdc
zpool create m2 mirror /dev/sdd /dev/sde
zpool create m3 mirror /dev/sdf /dev/sdg
zpool create m4 mirror /dev/sdh /dev/sdi

zfs set compression=lzjb m1
zfs set compression=lz4 m2
zfs set compression=gzip-9 m3
zfs set compression=zle m4

zfs get all | grep compression

for i in {1..4}; do wget -P /m$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done
ls -l /m*
zfs list
zfs get all | grep compressratio | grep -v ref
cd /root
wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download'
tar -xzvf archive.tar.gz
zpool import -d zpoolexport/ otus
zpool status

zfs get available otus
zfs get readonly otus
zfs get recordsize otus
zfs get compression otus
zfs get checksum otus
wget -O otus_task2.file --no-check-certificate https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download
sleep 20
zfs receive otus/test@today < /root/otus_task2.file
find /otus/test -name "secret_message"
cat /otus/test/task1/file_mess/secret_message
