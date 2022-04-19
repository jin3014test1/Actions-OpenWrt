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
# git clone https://github.com/jin3014test1/luci-app-smartdns package/luci-app-smartdns
# git clone --depth=1 https://github.com/fw876/helloworld.git package/helloworld







cat>./target/linux/ramips/dts/mt7621_zte_e8820v2.dts<<EOF
/dts-v1/;
#include "mt7621.dtsi"
#include <dt-bindings/gpio/gpio.h>
#include <dt-bindings/input/input.h>
/ {
    compatible = "zte,e8820v2", "mediatek,mt7621-soc";
    model = "ZTE E8820V2";
   
    aliases {
        led-boot = &led_sys;
        led-failsafe = &led_sys;
        led-running = &led_sys;
        led-upgrade = &led_sys;
    };
    chosen {
        bootargs = "console=ttyS0,115200";
    };
    leds {
        compatible = "gpio-leds";
        led_sys:sys {
            label = "e8820v2:white:sys";
            gpios = <&gpio 29 GPIO_ACTIVE_LOW>;
        };   
        led_power:power {
            label = "e8820v2:white:power";
            gpios = <&gpio 31 GPIO_ACTIVE_LOW>;            
        };
    };
    keys {
        compatible = "gpio-keys";
        reset {
            label = "reset";
            gpios = <&gpio 18 GPIO_ACTIVE_LOW>;
            linux,code = <KEY_RESTART>;
        };
        wps {
            label = "wps";
            gpios = <&gpio 24 GPIO_ACTIVE_LOW>;
            linux,code = <KEY_WPS_BUTTON>;
        };
    };
};
&spi0 {
    status = "okay";
    m25p80@0 {
        compatible = "jedec,spi-nor";
        reg = <0>;
        spi-max-frequency = <10000000>;
        partitions {
            compatible = "fixed-partitions";
            #address-cells = <1>;
            #size-cells = <1>;
            partition@0 {
                label = "u-boot";
                reg = <0x0 0x30000>;
                read-only;
            };
            partition@30000 {
                label = "u-boot-env";
                reg = <0x30000 0x10000>;
                read-only;
            };
            factory: partition@40000 {
                label = "factory";
                reg = <0x40000 0x10000>;
                read-only;
            };
            partition@50000 {
                compatible = "denx,uimage";
                label = "firmware";
                reg = <0x50000 0xfb0000>;
            };
        };
    };
};
&pcie {
    status = "okay";
};
&pcie0 {
    mt76@0,0 {
        reg = <0x0000 0 0 0 0>;
        mediatek,mtd-eeprom = <&factory 0x0000>;
        led {
            led-active-low;
        };
    };
};
&pcie1 {
    mt76@0,0 {
        reg = <0x0000 0 0 0 0>;
        mediatek,mtd-eeprom = <&factory 0x8000>;
        ieee80211-freq-limit = <5000000 6000000>;
        led {
            led-sources = <2>;
            led-active-low;
        };
    };
};
&gmac0 {
    mtd-mac-address = <&factory 0xe000>;
};
&switch0 {
    ports {
        port@4 {
            status = "okay";
            label = "wan";
            mtd-mac-address = <&factory 0xe006>;
        };
        port@0 {
            status = "okay";
            label = "lan1";
        };
        port@1 {
            status = "okay";
            label = "lan2";
        };
        port@2 {
            status = "okay";
            label = "lan3";
        };
        port@3 {
            status = "okay";
            label = "lan4";
        };
    };
};
&state_default {
    gpio {
        groups = "i2c", "uart2", "uart3", "wdt";
        function = "gpio";
    };
};
EOF

#增加LED
sed -i 's/^esac/zte,e8820v2)\
                                ucidef_set_led_netdev"sys" "SYS_LED" "$boardname:white:sys""eth0" "tx rx"\
                                ucidef_set_led_default"power" "POWER_LED" "$boardname:white:power""1"\
;;\
esac/g' ./target/linux/ramips/mt7621/base-files/etc/board.d/01_leds

	

#增加驱动

sed -i '$a define Device/zte_e8820v2\
  IMAGE_SIZE := 16064k\
  DEVICE_VENDOR := ZTE\
  DEVICE_MODEL := E8820V2\
  DEVICE_PACKAGES :=     kmod-mt7603 kmod-mt76x2 kmod-usb3 kmod-usb-ledtrig-usbport wpad luci\
endef\
TARGET_DEVICES += zte_e8820v2' ./target/linux/ramips/image/mt7621.mk
