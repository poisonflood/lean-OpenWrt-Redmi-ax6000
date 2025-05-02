#!/bin/bash
#
# Copyright (c) 2019-2023 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
#echo 'src-git messense https://github.com/messense/aliyundrive-webdav' >>feeds.conf.default

# https://github.com/DHDAXCW/OpenWRT_x86_x64/blob/main/immortalwrt/diy-part1.sh
# # Clone community packages to package/community
# mkdir package/community
# pushd package/community
# git clone --depth=1 https://github.com/fw876/helloworld
# git clone --depth=1 https://github.com/nikkinikki-org/OpenWrt-nikki
# git clone --depth=1 https://github.com/DHDAXCW/dhdaxcw-app
# git clone --depth=1 https://github.com/linkease/istore
# popd
#
