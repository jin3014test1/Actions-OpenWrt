#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#


# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate


# Modify default IP
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate


# git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
# git clone -b lede https://github.com/jin3014test1/luci-app-smartdns.git package/luci-app-smartdns
git clone https://github.com/siwind/openwrt-vlmcsd package/vlmcsd
git clone https://github.com/siwind/luci-app-vlmcsd.git package/luci-app-vlmcsd
# git clone https://github.com/siwind/luci-app-usb_printer.git package/luci-app-usb_printer


# 加入E8820S支持

wget https://gitee.com/jin3014/openwrt/raw/master/target/linux/ramips/dts/mt7621_zte_e8820s.dts
wget https://gitee.com/jin3014/openwrt/raw/master/target/linux/ramips/mt7621/base-files/etc/board.d/01_leds
wget https://gitee.com/jin3014/openwrt/raw/master/target/linux/ramips/mt7621/base-files/lib/upgrade/platform.sh
wget https://gitee.com/jin3014/openwrt/raw/master/target/linux/ramips/image/mt7621.mk

rsync -a  mt7621_zte_e8820s.dts target/linux/ramips/dts
rsync -a  01_leds target/linux/ramips/mt7621/base-files/etc/board.d
rsync -a  platform.sh target/linux/ramips/mt7621/base-files/lib/upgrade
rsync -a  mt7621.mk target/linux/ramips/image

rm  mt7621_zte_e8820s.dts 01_leds  platform.sh mt7621.mk


# smartdns
#cd openwrt
#sudo rm -rf feeds/luci/applications/luci-app-smartdns
#sudo rm -rf package/feeds/luci/luci-app-smartdns
#sudo rm -rf feeds/packages/net/smartdns
#sudo rm -rf package/feeds/packages/smartdns
#svn co https://github.com/kenzok8/small-package/trunk/luci-app-smartdns package/diy/luci-app-smartdns
#svn co https://github.com/kenzok8/small-package/trunk/smartdns package/diy/smartdns
