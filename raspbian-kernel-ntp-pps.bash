#! /bin/bash

export KERNEL=kernel7
apt-get update -y
apt-get dist-upgrade -y
apt-get install -y linux-4.4-source-4.4 ncurses-dev
tar -C /usr/src -x -f linux-4.4-source-4.4.tar.xz
sync
cd /usr/src/linux-4.4-source-4.4
make mrproper
modprobe configs
zcat /proc/config.gz > .config
sed 's/CONFIG_NO_HZ=y/# CONFIG_NO_HZ is not set/' .config -i
echo "CONFIG_NTP_PPS=y" >> .config
yes "N" | make oldconfig
make -j4 zImage modules dtbs
make modules_install
cp arch/arm/boot/dts/*.dtb /boot/
cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
cp arch/arm/boot/dts/overlays/README /boot/overlays/
scripts/mkknlimg arch/arm/boot/zImage /boot/$KERNEL.img
