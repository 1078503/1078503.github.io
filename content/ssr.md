---
title: "酸酸乳"
date: 2019-08-18T02:38:36+08:00
draft: true
---

# 此文档放置站点目录是为了私用时方便，请勿传播！

这是秋水逸冰大佬的脚本备份。

## 1.[一键安装最新内核并开启 BBR 脚本](https://teddysun.com/489.html)

本脚本适用环境

系统支持：CentOS 6+，Debian 7+，Ubuntu 12+
虚拟技术：OpenVZ 以外的，比如 KVM、Xen、VMware 等
内存要求：≥128M
日期　　：2018 年 12 月 14 日

关于本脚本

1、本脚本已在 [**Vultr**](https://www.vultr.com/) 上的 VPS 全部测试通过。
2、当脚本检测到 VPS 的虚拟方式为 OpenVZ 时，会提示错误，并自动退出安装。
3、脚本运行完重启发现开不了机的，打开 VPS 后台控制面板的 VNC, 开机卡在 grub 引导, 手动选择内核即可。
4、由于是使用最新版系统内核，最好请勿在生产环境安装，以免产生不可预测之后果。

**使用方法** 

使用root用户登录，运行以下命令：

```shell
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
```

安装完成后，脚本会提示需要重启 VPS，输入 y 并回车后重启。
重启完成后，进入 VPS，验证一下是否成功安装最新内核并开启 TCP BBR，输入以下命令：

```shell
uname -r
```

查看内核版本，显示为最新版就表示 OK 了

```shell
sysctl net.ipv4.tcp_available_congestion_control
```

返回值一般为：
net.ipv4.tcp_available_congestion_control = bbr cubic reno

或者为：
net.ipv4.tcp_available_congestion_control = reno cubic bbr

```shell
sysctl net.ipv4.tcp_congestion_control
```

返回值一般为：
net.ipv4.tcp_congestion_control = bbr

```shell
sysctl net.core.default_qdisc
```

返回值一般为：
net.core.default_qdisc = fq

```shell
lsmod | grep bbr
```

返回值有 tcp_bbr 模块即说明 bbr 已启动。`注意`：并不是所有的 VPS 都会有此返回值，若没有也属正常。

## 2.CentOS 下最新版内核 headers 安装方法 

本来打算在脚本里直接安装 kernel-ml-headers，但会出现和原版内核 headers 冲突的问题。因此在这里添加一个脚本执行完后，手动安装最新版内核 headers 之教程。
执行以下命令

```shell
yum --enablerepo=elrepo-kernel -y install kernel-ml-headers
```

根据 CentOS 版本的不同，此时一般会出现类似于以下的错误提示：

```shell
Error: kernel-ml-headers conflicts with kernel-headers-2.6.32-696.20.1.el6.x86_64
Error: kernel-ml-headers conflicts with kernel-headers-3.10.0-693.17.1.el7.x86_64
```

因此需要先卸载原版内核 headers ，然后再安装最新版内核 headers。执行命令：

```shell
yum remove kernel-headers
```

确认无误后，输入 y，回车开始卸载。注意，有时候这么操作还会卸载一些对内核 headers 依赖的安装包，比如 gcc、gcc-c++ 之类的。不过不要紧，我们可以在安装完最新版内核 headers 后再重新安装回来即可。
卸载完成后，再次执行上面给出的安装命令。

```shell
yum --enablerepo=elrepo-kernel -y install kernel-ml-headers
```

成功安装后，再把那些之前对内核 headers 依赖的安装包，比如 gcc、gcc-c++ 之类的再安装一次即可。

为什么要安装最新版内核 headers 呢？
这是因为 shadowsocks-libev 版有个 tcp fast open 功能，如果不安装的话，这个功能是无法开启的。

#### 内核升级方法

**如果是 CentOS 系统，执行如下命令即可升级内核：**

```shell
yum -y install kernel-ml kernel-ml-devel
```

如果你还手动安装了新版内核 headers ，那么还需要以下命令来升级 headers ：

```shell
yum -y install kernel-ml-headers
```

CentOS 6 的话，执行命令：

```shell
sed -i 's/^default=.*/default=0/g' /boot/grub/grub.conf
```

CentOS 7 的话，执行命令：

```shell
grub2-set-default 0
```

**如果是 Debian/Ubuntu 系统，则需要手动下载最新版内核来安装升级。**
去[这里](http://kernel.ubuntu.com/~kernel-ppa/mainline/)下载最新版的内核 deb 安装包。
如果系统是 64 位，则下载 amd64 的 linux-image 中含有 generic 这个 deb 包；
如果系统是 32 位，则下载 i386 的 linux-image 中含有 generic 这个 deb 包；
安装的命令如下（以最新版的 64 位 4.12.4 举例而已，请替换为下载好的 deb 包）：

```shell
dpkg -i linux-image-4.12.4-041204-generic_4.12.4-041204.201707271932_amd64.deb
```

安装完成后，再执行命令：

```shell
/usr/sbin/update-grub
```

最后，重启 VPS 即可。

## 特别说明 

如果你使用的是 Google Cloud Platform （GCP）更换内核，有时会遇到重启后，整个磁盘变为只读的情况。只需执行以下命令即可恢复：

```shell
mount -o remount rw /
```

---

## 3.[ShadowsocksR一键安装脚本](https://shadowsocks.be/9.html)            https://teddysun.com/

本脚本适用环境： 系统支持：CentOS，Debian，Ubuntu 内存要求：≥128M 日期：2018 年 02 月 07 日

**关于本脚本：** 一键安装 ShadowsocksR 服务端。 请下载与之配套的客户端程序来连接。 （以下客户端只有 [Windows 客户端](https://github.com/shadowsocksrr/shadowsocksr-csharp/releases)和 [Python 版客户端](https://github.com/shadowsocksr-backup/shadowsocks-rss/wiki/Python-client)可以使用 SSR 新特性，其他原版客户端只能以兼容的方式连接 SSR 服务器）

**默认配置：** 

服务器端口：自己设定（如不设定，默认从 9000-19999 之间随机生成） 

密码：自己设定（如不设定，默认为 teddysun.com） 

加密方式：自己设定（如不设定，默认为 aes-256-cfb） 

协议（Protocol）：自己设定（如不设定，默认为 origin） 

混淆（obfs）：自己设定（如不设定，默认为 plain）

**客户端下载：**

[Windows](https://github.com/shadowsocksrr/shadowsocksr-csharp/releases) / [OS X](https://github.com/shadowsocks/shadowsocks-iOS/wiki/Shadowsocks-for-OSX-Help)
[Linux](https://github.com/librehat/shadowsocks-qt5)
[Android](https://github.com/shadowsocks/shadowsocks-android) / [iOS](https://github.com/shadowsocks/shadowsocks-iOS/wiki/Help)
[OpenWRT](https://github.com/shadowsocks/openwrt-shadowsocks)

**使用方法：** 使用root用户登录，运行以下命令：

```shell
wget --no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocksR.sh
chmod +x shadowsocksR.sh
./shadowsocksR.sh 2>&1 | tee shadowsocksR.log
```

安装完成后，脚本提示如下：

```shell
Congratulations, ShadowsocksR server install completed!
Your Server IP        :your_server_ip
Your Server Port      :your_server_port
Your Password         :your_password
Your Protocol         :your_protocol
Your obfs             :your_obfs
Your Encryption Method:your_encryption_method
​
Welcome to visit:https://shadowsocks.be/9.html
Enjoy it!
```

`不出意外，到这里你就能愉快的科学上网了。`

**卸载方法：** 使用 root 用户登录，运行以下命令：

```shell
./shadowsocksR.sh uninstall
```

安装完成后即已后台启动 ShadowsocksR ，运行：

```shell
/etc/init.d/shadowsocks status
```

可以查看 ShadowsocksR 进程是否已经启动。 本脚本安装完成后，已将 ShadowsocksR 自动加入开机自启动。

**使用命令：**

启动：/etc/init.d/shadowsocks start

停止：/etc/init.d/shadowsocks stop

重启：/etc/init.d/shadowsocks restart

状态：/etc/init.d/shadowsocks status

配置文件路径：/etc/shadowsocks.json

日志文件路径：/var/log/shadowsocks.log

代码安装目录：/usr/local/shadowsocks

**多用户配置示例：**

```json
{
"server":"0.0.0.0",
"server_ipv6": "[::]",
"local_address":"127.0.0.1",
"local_port":1080,
"port_password":{
    "8989":"password1",
    "8990":"password2",
    "8991":"password3"
},
"timeout":300,
"method":"aes-256-cfb",
"protocol": "origin",
"protocol_param": "",
"obfs": "plain",
"obfs_param": "",
"redirect": "",
"dns_ipv6": false,
"fast_open": false,
"workers": 1
}
```

如果你想修改配置文件，请参考：

https://github.com/shadowsocksr-backup/shadowsocks-rss/wiki/Server-Setup

https://github.com/shadowsocksr-backup/shadowsocks-rss/blob/master/ssr.md

https://github.com/shadowsocksr-backup/shadowsocks-rss/wiki/config.json

 

**原文地址：**https://shadowsocks.be/9.html

查看当前配置信息：

```shell
cat /etc/shadowsocks.json
```