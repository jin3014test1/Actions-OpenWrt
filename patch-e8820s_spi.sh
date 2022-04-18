#! /bin/bash

cat>./target/linux/ramips/dts/mt7621_zte_e8820s_spi.dts<<EOF
// SPDX-License-Identifier: GPL-2.0-or-later OR MIT

#include "mt7621.dtsi"

#include <dt-bindings/gpio/gpio.h>
#include <dt-bindings/input/input.h>

/ {
	compatible = "zte,e8820s_spi", "mediatek,mt7621-soc";
	model = "ZTE E8820S_spi";

	aliases {
		led-boot = &led_sys;
		led-failsafe = &led_sys;
		led-running = &led_power;
		led-upgrade = &led_power;
		label-mac-device = &ethernet;
	};

	chosen {
		bootargs = "console=ttyS0,115200";
	};

	leds {
		compatible = "gpio-leds";

		led_power: power {
			label = "white:power";
			gpios = <&gpio 3 GPIO_ACTIVE_LOW>;
		};

		led_sys: sys {
			label = "white:sys";
			gpios = <&gpio 16 GPIO_ACTIVE_LOW>;
		};

		wlan2g {
			label = "white:wlan2g";
			gpios = <&gpio 14 GPIO_ACTIVE_LOW>;
		};

		wlan5g {
			label = "white:wlan5g";
			gpios = <&gpio 12 GPIO_ACTIVE_LOW>;
		};
	};

	keys {
		compatible = "gpio-keys";

		reset {
			label = "reset";
			gpios = <&gpio 18 GPIO_ACTIVE_HIGH>;
			linux,code = <KEY_RESTART>;
		};

		wps {
			label = "wps";
			gpios = <&gpio 8 GPIO_ACTIVE_LOW>;
			linux,code = <KEY_WPS_BUTTON>;
		};

		wifi {
			label = "wifi";
			gpios = <&gpio 10 GPIO_ACTIVE_LOW>;
			linux,code = <KEY_RFKILL>;
		};
	};
};

&spi0 {
	status = "okay";

	flash@0 {
		compatible = "jedec,spi-nor";
		reg = <0>;
		spi-max-frequency = <10000000>;
		broken-flash-reset;

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
	wifi@0,0 {
		compatible = "pci14c3,7603";
		reg = <0x0000 0 0 0 0>;
		mediatek,mtd-eeprom = <&factory 0x0000>;
		ieee80211-freq-limit = <2400000 2500000>;
	};
};

&pcie1 {
	wifi@0,0 {
		compatible = "pci14c3,7662";
		reg = <0x0000 0 0 0 0>;
		mediatek,mtd-eeprom = <&factory 0x8000>;
		ieee80211-freq-limit = <5000000 6000000>;
	};
};

&ethernet {
	compatible = "mediatek,ralink-mt7621-eth";
	mediatek,switch = <&gsw>;
	mtd-mac-address = <&factory 0xe006>;
};

&switch0 {
	/delete-property/ compatible;
	phy-mode = "rgmii";
};
&gsw {
	compatible = "mediatek,ralink-mt7621-gsw";
};

&state_default {
	gpio {
		groups = "jtag", "uart2", "uart3", "wdt";
		function = "gpio";
	};
};

EOF

#增加LED
sed -i 's/^esac/zte,e8820s_spi)\
	ucidef_set_led_netdev "wlan2g" "WiFi 2.4GHz" "white:wlan2g" "ra0"\
	ucidef_set_led_netdev "wlan5g" "WiFi 5GHz" "white:wlan5g" "rai0"\
	;;\
esac/g' ./target/linux/ramips/mt7621/base-files/etc/board.d/01_leds

#增加交换机
sed -i 's/d-team,newifi-d2/zte,e8820s_spi/g' ./target/linux/ramips/mt7621/base-files/etc/board.d/02_network
sed -i 's/"0:lan:4" "1:lan:3" "2:lan:2" "3:lan:1" "4:wan:5" "6@eth0"/"0:lan:1" "1:lan:2" "2:lan:3" "3:lan:4" "4:wan:5" "6@eth0"/g' ./target/linux/ramips/mt7621/base-files/etc/board.d/02_network

#增加驱动

sed -i 'define Device/zte_e8820s_spi\
  $(Device/dsa-migration)\
  $(Device/uimage-lzma-loader)\
  IMAGE_SIZE := 16064k\
  DEVICE_VENDOR := ZTE\
  DEVICE_MODEL := E8820S_spi\
  DEVICE_PACKAGES := kmod-mt7603 kmod-mt76x2 kmod-usb3 \
endef\
TARGET_DEVICES += zte_e8820s_spi' ./target/linux/ramips/image/mt7621.mk
