## KVM 安装部署(基于 CentOS7 )
- KVM 虚拟化需要 CPU 的硬件虚拟化加速的支持，在本环境中为 Intel 的 CPU，使用的 Intel VT 技术。(该功能在有些主机里面可能需要去 BIOS 里面开启)

- 在安装部署之前需要做准备工作
- 1、进BIOS开启虚拟化支持
- 2、关闭防火墙
- 3、关闭Selinux机制
- 4、开始安装检查CPU虚拟化支持
  
  ```bash
  grep -E 'svm|vmx' /proc/cpuinfo

  # vmx为Intel的CPU指令集
  # svm为AMD的CPU指令集
  ```

### 安装基本软件
- 安装 kvm 基本软件
  
  ```bash
  yum install qemu-kvm libvirt virt-install virt-manager
  ```

- 软件包介绍：
- `qemu-kvm`：该软件包主要包含 KVM 内核模块和基于 KVM 重构后的 QEMU 模拟器。 KVM 模块作为整个虚拟化环境的核心工作在系统空间，负责 CPU 和内存的调度。QEMU 作为模拟器工作在用户空间，负责虚拟机 I/O 模拟。
- `libvirt`：提供 Hypervisor 和虚拟机管理的 API
- `virt-install`：创建和克隆虚拟机的命令行工具包。
- `virt-manager`：图形界面的 KVM 管理工具。

### 基本配置激活并启动libvirtd服务
- 启动相关服务：
  
  ```bash
  systemctl enable libvirtd
  systemctl start libvirtd
  ```

### 配置桥接网络
- 默认情况下所有虚拟机只能够在 host 内部互相通信，如果需要通过局域网访问虚拟机，需要创建一个桥接网络。

- **停止 NetworkManager 服务**
  
  ```bash
  systemctl stop NetworkManager
  ```
- 该服务开启的情况下直接去修改网卡的配置文件会造成信息的不匹配而导致网卡激活不了。

- **修改以太网卡配置文件(参数只做参考)**
  
  ```bash
  cd /etc/sysconfig/network-scripts
  vi ifcfg-eno1
  ```

  ```bash
  DEVICE=eno1
  BOOTPROTO=static
  ONBOOT=yes
  BRIDGE=br0
  HWADDR=b8:ae:ed:7d:9d:11
  NM_CONTROLLED=no
  ```
- 原有的以太网络不需要配置IP地址，指定桥接的网卡设备(如br0)即可。

- **修改桥接网卡配置文件 `ifcfg-br0`**
  
  ```bash
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
- 桥接网卡的需要配置 IP 地址，当然也可以用 DHCP。需要注意的是桥接网卡 br0 中 DEVICE 的名字一定要与以太网卡 eno1 中 BRIDGE 对应。
- `NM_CONTROLLED` 参数表示该网卡是否被 `NetworkManager` 服务管理，设置为 no 的话就是不接管，那么之前不用停止 `NetworkManager` 服务。(未经测试)

### 开启主机IP地址转发
- 开启宿主机路由转发功能：
  
  ```bash
  vi /etc/sysctl.conf

  # 添加如下内容：
  net.ipv4.ip_forward = 1
  
  # 使其生效
  sysctl -p
  ```

### 重启网络服务
- 重启相关服务：
  
  ```bash
  systemctl restart network
  systemctl restart NetworkManager
  ```

### 验证内核模块
- 验证内核模块是否具有相关功能：
  ```bash
  lsmod |grep kvm
  ```

- 至此，KVM 虚拟机环境安装完成！
