# zte-e8820v2

对于zet-e8820v2，谋求原版openwrt自行修改dts不是业余人士能干的，我努力了一个多星期宣告放弃，目前找到的可用代码库是siwind的，他已经增补了dts等文件，虽然代码库不如原始openwrt/openwrt那么新，但好用。


#### 目前成果：

master版本编译正常，刷机能启动，运行良好。固件里只安装了kmod-usb-printer（我当ap用，还要连打印机），内核版本5.10.113，有r，无kv，可配置vlan。

19.07版本指定tag标签19.07.1代码库成功编译了固件，刷机后可运行，只是一直无法启动2g网络，剩余内存多了好几m，不过负载也高了几倍。不好用。试了试其他标签直接编译错误，死了1907版本的心了？

特别提出一点，menuconfig里我选了usb3支持，虽然这个机器硬件只是usb2，但选usb3才能成功识别usb打印机，我估计硬件芯片里是usb3的，外围缩水为usb2.


****
# zte-e8820s-spi

8820s为刷高恪硬改spi闪存，高恪玩够了，想刷回openwrt，我觉得改文件比改硬件方便些，所以。。。有了这。固件已经运行几天了，好用，内核版本5.10.113，有r，无kv，可配置vlan。另外预装的ddns、vlmcsd，没有其他的了。代码库来源于siwind，是否有恶意代码我就没能力鉴别了。我试openwrt/openwrt指定分支，都没能成功。  
SmartDNS在这个固件里一直显示收集数据，但dns功能没问题，网上也有人提出这个问题，估计luci不能适应最新的master源码，给作者去信了。----------这个不好用，最新版不会编译，只好删除了。

****
# zte-e8820s
买了个体视显微镜，再把spi改回nand，闲着无聊嘛，上面的spi固件运行良好，纯属闲着无聊。焊工还是不咋样，电阻适合用风枪，焊nand还是适合用电烙铁，这主板散热太快，烙铁温度设置到380度，一个脚一个脚焊，点一下一个脚也挺快。拖焊没弄成，大概温度设置还是太低或者烙铁回温慢。反正最后焊好，5g就彻底没了，换回spi也没有，换回原厂固件也没有（5g的mac都是0），可能是硬件碰坏哪里了。  
###### siwind库
__menuconfig时必要的选项是Luci---collection----Luci__，这个包含了路由器管理界面和防火墙，ipv6是默认自带的不用管。compat也要选，不然kms界面报错。upnp不知为何一直没有活动连接，我刷别的成品固件都能在启动彗星后出现活动重定向（虽然我的是内网一直黄灯）
###### lede库
都默认就行，不过启动比siwind慢很多，估计是默认插件太多，也许删掉五六个就能和siwind的差不多了


修改master版重新编译
