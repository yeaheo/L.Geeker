## KVM安装部署(基于CentOS7)
- KVM虚拟化需要CPU的硬件虚拟化加速的支持，在本环境中为Intel的CPU，使用的Intel VT技术。(该功能在有些主机里面可能需要去BIOS里面开启)

- 在安装部署之前需要做准备工作
  - 1、进BIOS开启虚拟化支持
  - 2、关闭防火墙
  - 3、关闭Selinux机制
  - 4、开始安装检查CPU虚拟化支持
    - `grep -E 'svm|vmx' /proc/cpuinfo`
    - vmx为Intel的CPU指令集
    - svm为AMD的CPU指令集
### 安装基本软件
- `yum install qemu-kvm libvirt virt-install virt-manager`
- 软件包介绍：
  - qemu-kvm：该软件包主要包含KVM内核模块和基于KVM重构后的QEMU模拟器。KVM模块作为整个虚拟化环境的核心工作在系统空间，负责CPU和内存的调度。QEMU作为模拟器工作在用户空间，负责虚拟机I/O模拟。
  - libvirt：提供Hypervisor和虚拟机管理的API
  - virt-install：创建和克隆虚拟机的命令行工具包。
  - virt-manager：图形界面的KVM管理工具。
### 基本配置激活并启动libvirtd服务
- `systemctl enable libvirtd`
- `systemctl start libvirtd`

### 配置桥接网络
- 默认情况下所有虚拟机只能够在host内部互相通信，如果需要通过局域网访问虚拟机，需要创建一个桥接网络。
- 1.停止NetworkManager服务
- `systemctl stop NetworkManager`
- 该服务开启的情况下直接去修改网卡的配置文件会造成信息的不匹配而导致网卡激活不了。
- 2.修改以太网卡配置文件(参数只做参考)
- `cd /etc/sysconfig/network-scripts`
- `vi ifcfg-eno1`
``` xml
DEVICE=eno1
BOOTPROTO=static
ONBOOT=yes
BRIDGE=br0
HWADDR=b8:ae:ed:7d:9d:11
NM_CONTROLLED=no
```
- 原有的以太网络不需要配置IP地址，指定桥接的网卡设备(如br0)即可。
- 3.修改桥接网卡配置文件
- `vi ifcfg-br0`
``` xml
TYPE=Bridge
HWADDR=b8:ae:ed:7d:9d:11
BOOTPROTO=static
DEVICE=br0
ONBOOT=yes
IPADDR=192.168.2.10
NETMASK=255.255.255.0
GATEWAY=192.168.2.1
DNS1=202.103.24.68
NM_CONTROLLED=no
```
- 桥接网卡的需要配置IP地址，当然也可以用DHCP。需要注意的是桥接网卡br0中DEVICE的名字一定要与以太网卡eno1中BRIDGE对应。
- NM_CONTROLLED参数表示该网卡是否被NetworkManager服务管理，设置为no的话就是不接管，那么之前不用停止NetworkManager服务。(未经测试)
### 开启主机IP地址转发
- `vi /etc/sysctl.conf`
- 添加如下内容：
``` xml
net.ipv4.ip_forward = 1
```
- ` sysctl -p`

### 重启网络服务
- `systemctl restart network`
- `systemctl restart NetworkManager`

### 验证内核模块
- `lsmod |grep kvm`

- 至此，KVM虚拟机环境安装完成！
