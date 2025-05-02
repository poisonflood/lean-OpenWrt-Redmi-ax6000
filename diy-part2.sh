#!/bin/bash
#
# Copyright (c) 2019-2023 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Custom for REDMI AX6000
# Modify default IP（FROM 192.168.1.1 CHANGE TO 10.10.10.1）
sed -i 's/192.168.1./10.10.10./g' $OPENWRT_DIR/package/base-files/files/bin/config_generate
sed -i 's/192.168.1./10.10.10./g' $OPENWRT_DIR/package/base-files/luci2/bin/config_generate
sed -i 's/192.168.1./10.10.10./g' $OPENWRT_DIR/package/base-files/Makefile
sed -i 's/192.168.1./10.10.10./g' $OPENWRT_DIR/package/base-files/image-config.in

#sed -i 's/ntp.aliyun.com/0.openwrt.pool.ntp.org/g' $OPENWRT_DIR/package/base-files/files/bin/config_generate
#sed -i 's/time1.cloud.tencent.com/1.openwrt.pool.ntp.org/g' $OPENWRT_DIR/package/base-files/files/bin/config_generate
#sed -i 's/time.ustc.edu.cn/2.openwrt.pool.ntp.org/g' $OPENWRT_DIR/package/base-files/files/bin/config_generate
#sed -i 's/cn.pool.ntp.org/3.openwrt.pool.ntp.org/g' $OPENWRT_DIR/package/base-files/files/bin/config_generate
sed -i 's/ntp.aliyun.com/0.openwrt.pool.ntp.org/g' $OPENWRT_DIR/package/base-files/luci2/bin/config_generate
sed -i 's/time1.cloud.tencent.com/1.openwrt.pool.ntp.org/g' $OPENWRT_DIR/package/base-files/luci2/bin/config_generate
sed -i 's/time.ustc.edu.cn/2.openwrt.pool.ntp.org/g' $OPENWRT_DIR/package/base-files/luci2/bin/config_generate
sed -i 's/cn.pool.ntp.org/3.openwrt.pool.ntp.org/g' $OPENWRT_DIR/package/base-files/luci2/bin/config_generate

# Remove all existing MODPARAMS lines (if any)
sed -i '/MODPARAMS.mt7915e:=wed_enable=Y/d' $OPENWRT_DIR/package/kernel/mt76/Makefile
# Add once after AUTOLOAD
sed -i '/AUTOLOAD:=$(call AutoProbe,mt7915e)/a \  MODPARAMS.mt7915e:=wed_enable=Y' $OPENWRT_DIR/package/kernel/mt76/Makefile

#cp $WORK_DIR/lean/Redmi-AX6000/data/ddns.config $OPENWRT_DIR/feeds/packages/net/ddns-scripts/files/
cp $WORK_DIR/lean/Redmi-AX6000/data/etc/banner $OPENWRT_DIR/package/base-files/files/etc/
#cp $WORK_DIR/lean/Redmi-AX6000/data/etc/mtd-rw package/base-files/files/etc/init.d/
#chmod 0755 package/base-files/files/etc/init.d/mtd-rw
cp $WORK_DIR/lean/Redmi-AX6000/data/default-settings/zzz-default-settings $OPENWRT_DIR/package/lean/default-settings/files/
cp $WORK_DIR/lean/Redmi-AX6000/data/default-settings/Makefile $OPENWRT_DIR/package/lean/default-settings/
#cp $WORK_DIR/lean/Redmi-AX6000/data/autocore/index.htm package/lean/autocore/files/arm/
#cp $WORK_DIR/lean/Redmi-AX6000/data/zones.lua $OPENWRT_DIR/feeds/luci/applications/luci-app-unbound/luasrc/model/cbi/firewall/
#cp $WORK_DIR/lean/Redmi-AX6000/data/mt7986a-xiaomi-redmi-router-ax6000.dts target/linux/mediatek/dts/
#cp $WORK_DIR/lean/Redmi-AX6000/data/leds-ws2812b.c $OPENWRT_DIR/package/kernel/leds-ws2812b/src/
#sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=6.1/g' target/linux/mediatek/Makefile
