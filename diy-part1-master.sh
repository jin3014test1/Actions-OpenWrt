#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate
# git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
# git clone -b lede https://github.com/jin3014test1/luci-app-smartdns.git package/luci-app-smartdns
# git clone --depth=1 https://github.com/fw876/helloworld.git package/helloworld
# git clone https://github.com/siwind/openwrt-vlmcsd package/vlmcsd
# git clone https://github.com/siwind/luci-app-vlmcsd.git package/luci-app-vlmcsd
# git clone https://github.com/siwind/luci-app-usb_printer.git package/luci-app-usb_printer


# 加入E8820S支持
wget https://raw.githubusercontent.com/jin3014test1/Actions-OpenWrt/main/code.tar.gz
tar -zxvf code.tar.gz
sh code/append.sh
#顺手把补丁删了
rm -rf  code code.tar.gz


# smartdns
#cd openwrt
#sudo rm -rf feeds/luci/applications/luci-app-smartdns
#sudo rm -rf package/feeds/luci/luci-app-smartdns
#sudo rm -rf feeds/packages/net/smartdns
#sudo rm -rf package/feeds/packages/smartdns
#svn co https://github.com/kenzok8/small-package/trunk/luci-app-smartdns package/diy/luci-app-smartdns
#svn co https://github.com/kenzok8/small-package/trunk/smartdns package/diy/smartdns
