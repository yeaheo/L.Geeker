## CentOS系统内核升级

- 虽然有些人使用 Linux 来表示整个操作系统，但要注意的是，严格地来说，Linux 只是个内核。另一方面，发行版是一个完整功能的系统，它建立在内核之上，具有各种各样的应用程序工具和库
- 一般情况下，内核负责执行两个重要任务：
- 1、作为硬件和系统上运行的软件之间的接口
- 2、尽可能高效的管理系统资源
- 为此，内核通过内置的驱动程序或以后可作为模块安装的驱动程序与硬件通信。
- 例如，当你计算机上运行的程序想要连接到无线网络时，它会将该请求提交给内核，后者又会使用正确的驱动程序连接到网络。
- 随着新的设备和技术定期出来，如果我们想充分利用它们，保持最新的内核就很重要。此外，更新内核将帮助我们利用新的内核函数，并保护自己免受先前版本中发现的漏洞的攻击。

- 这次，我们需要在CentOS7系统上安装最新稳定版的内核，具体系统信息如下：
  
  ```bash
  [root@ceph-node1 ~]# cat /etc/system-release
  CentOS Linux release 7.4.1708 (Core) 
  [root@ceph-node1 ~]# uname -a
  Linux ceph-node1 3.10.0-693.5.2.el7.x86_64 #1 SMP Fri Oct 20 20:32:50 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
  ```
- Linux 内核官网：<https://www.kernel.org>
- 目前，最新稳定版的内核版本为 4.14.2
- 有时候我们还要考虑的一个重要的事情是内核版本的生命周期，如果你当前使用的版本接近它的生命周期结束，那么在该日期后将不会提供更多的 bug 修复。
关于内核的生命周期，请参阅[内核发布信息](https://www.kernel.org/category/releases.html)。

### CentOS 7系统升级内核
- 大多数现代发行版提供了一种使用 yum 等[rpm包管理系统](https://www.tecmint.com/20-linux-yum-yellowdog-updater-modified-commands-for-package-mangement/)和官方支持的仓库升级内核的方法。
- 但是，这只会升级内核到仓库中可用的最新版本,而不是在内核官网中提到的最新版本，其中Red Hat只允许使用前者升级内核。
- 与 Red Hat 不同，CentOS 允许使用 ELRepo，这是一个第三方仓库，可以将内核升级到最新版本。

- **启用ELRepo仓库**
  
  ```bash
  rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
  rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
  ```

- **查看可用的内核相关包**
  
  ```bash
  [root@ceph-deploy ~]# yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
  Loaded plugins: fastestmirror
  Loading mirror speeds from cached hostfile
  * elrepo-kernel: mirrors.tuna.tsinghua.edu.cn
  Available Packages
  kernel-lt.x86_64                                   4.4.102-1.el7.elrepo                   elrepo-kernel
  kernel-lt-devel.x86_64                             4.4.102-1.el7.elrepo                   elrepo-kernel
  kernel-lt-doc.noarch                               4.4.102-1.el7.elrepo                   elrepo-kernel
  kernel-lt-headers.x86_64                           4.4.102-1.el7.elrepo                   elrepo-kernel
  kernel-lt-tools.x86_64                             4.4.102-1.el7.elrepo                   elrepo-kernel
  kernel-lt-tools-libs.x86_64                        4.4.102-1.el7.elrepo                   elrepo-kernel
  kernel-lt-tools-libs-devel.x86_64                  4.4.102-1.el7.elrepo                   elrepo-kernel
  kernel-ml-devel.x86_64                             4.14.2-1.el7.elrepo                    elrepo-kernel
  kernel-ml-doc.noarch                               4.14.2-1.el7.elrepo                    elrepo-kernel
  kernel-ml-headers.x86_64                           4.14.2-1.el7.elrepo                    elrepo-kernel
  kernel-ml-tools.x86_64                             4.14.2-1.el7.elrepo                    elrepo-kernel
  kernel-ml-tools-libs.x86_64                        4.14.2-1.el7.elrepo                    elrepo-kernel
  kernel-ml-tools-libs-devel.x86_64                  4.14.2-1.el7.elrepo                    elrepo-kernel
  perf.x86_64                                        4.14.2-1.el7.elrepo                    elrepo-kernel
  python-perf.x86_64              
  ```
- 其中 `kernel-ml` 为我们需要安装的内核版本

- **安装最新的主线稳定内核**
  
  ```bash
  yum --enablerepo=elrepo-kernel install kernel-ml
  ```

### 设置 GRUB 默认的内核版本
- 为了让新安装的内核成为默认启动选项，需要修改GRUB相关配置，具体操作如下：
- 打开 `/etc/default/grub` 文件并作如下配置：
  
  ```bash
  GRUB_DEFAULT=0  # GRUB 初始化页面的第一个内核将作为默认内核
  GRUB_TIMEOUT=5
  GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
  GRUB_DEFAULT=0  # GRUB 初始化页面的第一个内核将作为默认内核
  GRUB_DISABLE_SUBMENU=true
  GRUB_TERMINAL_OUTPUT="console"
  GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet"
  GRUB_DISABLE_RECOVERY="true"
  ```
- **重新创建内核配置**
  ```bash
  grub2-mkconfig -o /boot/grub2/grub.cfg
  ```
- 重启并验证最新的内核已作为默认内核。
  
