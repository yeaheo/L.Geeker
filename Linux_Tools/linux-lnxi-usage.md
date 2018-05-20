## Linux 中获取完整硬件信息的命令行工具——Inxi
- Inxi 是一个可以获取完整的系统和硬件详情信息的命令行工具
- 例如： CPU、 磁盘、 内存、 显卡、 声卡、 网卡、 RAID等信息

#### 安装方式
- 在这里我们以 CentOS 或者 RedHa t系统为例，其他系统请自行找资料，区别不大。
- 我们用 yum 的方式进行安装比较方便，可以用官方自带的 yum 源，也可以安装国内的 yum 源，具体参考[更换国内yum源](linux-use-cn-yum-source.md)
- 准备工作：
 
  ```bash
  yum -y install epel-release
  yum clean all && yum makecache
  ```

- 正式安装：
  
  ```bash
  yum -y install inxi
  ```
  
#### 安装完成后，我们就可以尽情使用它了
- 1、获取系统的概况信息
  
  ```bash
  # inxi
  CPU~Single core Intel Core i5-5200U (-UP-) 
  speed~2200 MHz (max) 
  Kernel~3.10.0-514.21.2.el7.x86_64 x86_64 Up~38 min 
  Mem~395.1/976.5MB HDD~21.5GB(39.1% used) 
  Procs~93 Client~Shell inxi~2.3.23  
  ```
- 2、获取硬件的机型、主板、BIOS等信息
  
  ```bash
  # inxi -M
  Machine:   
  Device: vmware 
  System: VMware 
  product: VMware Virtual Platform 
  serial: VMware-56 4d 2a 7c ae 6a 3b 7b-65 19 ef 65 78 11 47 38
  Mobo: Intel 
  model: 440BX Desktop Reference Platform 
  BIOS: Phoenix v: 6.00 date: 07/02/2015
  ```
- 3、获取 CPU及主频信息（多CPU或多核心CPU都可以）
  
  ```bash
  # inxi -C
  CPU: Single core Intel Core i5-5200U (-UP-) cache: 3072 KB speed: 2200 MHz (max)
  ```
- 4、获取内存的信息
  
  ```bash
  # inxi -m
  Memory:    Used/Total: 396.7/976.5MB
  ```
- 5、获取RAID的相关信息
  
  ```bash
  # inxi -R
  RAID:      No RAID devices: /proc/mdstat, md_mod kernel module present
  ```
- 6、获取硬盘信息，包含品牌、硬盘大小、型号等信息
 
  ```bash
  # inxi -D
  Drives:    HDD Total Size: 21.5GB (39.1% used)
             ID-1: /dev/sda model: VMware_Virtual_S size: 21.5GB
  ```
- 7、获取硬盘分区信息，包含分区大小、已用空间、剩余空间、文件系统类型等信息
 
  ```bash
  # inxi -p
  Partition: ID-1: / size: 17G used: 5.8G (34%) fs: xfs dev: /dev/dm-0
             ID-2: /boot size: 1014M used: 212M (21%) fs: xfs dev: /dev/sda1
             ID-3: swap-1 size: 2.15GB used: 0.01GB (0%) fs: swap dev: /dev/dm-1
  ```
- 8、获取硬盘的 UUID 信息
  
  ```bash
  # inxi -u
  Partition: ID-1: / size: 17G used: 5.8G (34%) fs: xfs dev: /dev/dm-0 
             uuid: b00d236d-3fbe-4f91-9f17-66778855ba5d
             ID-2: /boot size: 1014M used: 212M (21%) fs: xfs dev: /dev/sda1
             uuid: 597beb1c-ada9-4efb-9303-1c39d2f0887f
             ID-3: swap-1 size: 2.15GB used: 0.01GB (0%) fs: swap dev: /dev/dm-1
             uuid: bb3ed18b-0582-4404-b184-869b6b10d2be
  ```
- 9、获取显卡信息，包含显卡类型、显示服务器、分辨率等信息
  
  ```bash
  # inxi -G
  Graphics:  Card: VMware SVGA II Adapter
  Display Server: N/A driver: N/A tty size: 133x28 Advanced Data: N/A for root out of X
  ```
- 10、获取网卡信息
 
  ```bash
  # inxi -N
  Network:   Card: Intel 82545EM Gigabit Ethernet Controller (Copper) driver: e1000
  ```
- 11、获取声卡信息
  
  ```bash
  # inxi -A
  ```
- 12、获取内核和发行版本信息，包含主机名、内核版本信息、发行版等信息
  
  ```bash
  # inxi -S
  System:    Host: ansible.yeah.com Kernel: 3.10.0-514.21.2.el7.x86_64 x86_64 (64 bit) Console: tty 0
             Distro: CentOS Linux release 7.3.1611 (Core)
  ```
- 13、获取 CPU温度和电脑风扇转速信息
  
  ```bash
  # inxi -s
  Sensors:   System Temperatures: cpu: 100.0C mobo: N/A
           Fan Speeds (in rpm): cpu: N/A
  ```
- 14、获取 Linux 运行进程的内存使用信息，包含内存使用情况、进程数、开机信息、运行级别、shell类型等信息
  
  ```bash
  # inxi -I
  Info:      Processes: 92 Uptime: 1:06 Memory: 395.2/976.5MB Init: systemd runlevel: 3
           Client: Shell (bash) inxi: 2.3.23 
  ```
- 15、获取进程使用的 CPU和内存信息，只获取前10个进程的相关信息
  
  ```bash
  # inxi -t cm 10
  Processes: CPU: % used - top 5 active
           1: cpu: 0.3% command: vmtoolsd pid: 629
           2: cpu: 0.1% daemon: ~kworker/u256:2~ pid: 2340
           3: cpu: 0.1% daemon: ~kworker/0:1~ pid: 2305
           4: cpu: 0.1% command: mysqld pid: 2180
           5: cpu: 0.1% daemon: ~kworker/u256:1~ pid: 38
           Memory: MB / % used - Used/Total: 395.3/976.5MB - top 5 active
           1: mem: 180.61MB (18.4%) command: mysqld pid: 2180
           2: mem: 14.51MB (1.4%) command: dhclient pid: 686
           3: mem: 14.24MB (1.4%) command: python pid: 863
           4: mem: 9.61MB (0.9%) command: polkitd pid: 630
           5: mem: 5.73MB (0.5%) command: rsyslogd pid: 864
  ```
- 16、获取各种网络设备信息，包含网卡、接口、网卡频率、MAC地址、IP等信息
  
  ```bash
  # inxi -Nni
  Network:   Card: Intel 82545EM Gigabit Ethernet Controller (Copper) driver: e1000
           IF: ens33 state: up speed: 1000 Mbps duplex: full mac: 00:0c:29:11:47:38
           WAN IP: 106.39.69.26
           IF: ens33 ip-v4: 6.6.6.11 ip-v6-link: fe80::ebde:558a:cf5b:b3be
  ```
- 17、获取简要的硬件和系统信息，包含CPU、磁盘、网卡、显卡、声卡等信息
  
  ```bash
  # inxi -b
  System:    Host: ansible.yeah.com Kernel: 3.10.0-514.21.2.el7.x86_64 x86_64 (64 bit) Console: tty 0
             Distro: CentOS Linux release 7.3.1611 (Core)
  Machine:   Device: vmware System: VMware product: VMware Virtual Platform serial: VMware-56 4d 2a 7c ae 6a 3b 7b-65 19 ef 65 78 11 47 38
             Mobo: Intel model: 440BX Desktop Reference Platform BIOS: Phoenix v: 6.00 date: 07/02/2015
  CPU:       Single core Intel Core i5-5200U (-UP-) speed: 2200 MHz (max)
  Graphics:  Card: VMware SVGA II Adapter
             Display Server: N/A driver: N/A tty size: 133x28 Advanced Data: N/A for root out of X
  Network:   Card: Intel 82545EM Gigabit Ethernet Controller (Copper) driver: e1000
  Drives:    HDD Total Size: 21.5GB (39.1% used)
  Info:      Processes: 93 Uptime: 1:11 Memory: 395.4/976.5MB Init: systemd runlevel: 3
             Client: Shell (bash) inxi: 2.3.23 
  ```
- 18、获取更加详细的 Linux硬件和系统信息
  
  ```bash
  # inxi -F
  System:    Host: ansible.yeah.com Kernel: 3.10.0-514.21.2.el7.x86_64 x86_64 (64 bit) Console: tty 0
             Distro: CentOS Linux release 7.3.1611 (Core)
  Machine:   Device: vmware System: VMware product: VMware Virtual Platform serial: VMware-56 4d 2a 7c ae 6a 3b 7b-65 19 ef 65 78 11 47 38
             Mobo: Intel model: 440BX Desktop Reference Platform BIOS: Phoenix v: 6.00 date: 07/02/2015
  CPU:       Single core Intel Core i5-5200U (-UP-) cache: 3072 KB speed: 2200 MHz (max)
  Graphics:  Card: VMware SVGA II Adapter
             Display Server: N/A driver: N/A tty size: 133x28 Advanced Data: N/A for root out of X
  Network:   Card: Intel 82545EM Gigabit Ethernet Controller (Copper) driver: e1000
             IF: ens33 state: up speed: 1000 Mbps duplex: full mac: 00:0c:29:11:47:38
  Drives:    HDD Total Size: 21.5GB (39.1% used)
             ID-1: /dev/sda model: VMware_Virtual_S size: 21.5GB
  Partition: ID-1: / size: 17G used: 5.8G (34%) fs: xfs dev: /dev/dm-0
             ID-2: /boot size: 1014M used: 212M (21%) fs: xfs dev: /dev/sda1
             ID-3: swap-1 size: 2.15GB used: 0.01GB (0%) fs: swap dev: /dev/dm-1 
  RAID:      No RAID devices: /proc/mdstat, md_mod kernel module present
  Sensors:   System Temperatures: cpu: 100.0C mobo: N/A
             Fan Speeds (in rpm): cpu: N/A
  Info:      Processes: 92 Uptime: 1:12 Memory: 395.2/976.5MB Init: systemd runlevel: 3
             Client: Shell (bash) inxi: 2.3.23 
  ```
- 19、获取某个硬件的更加详细的额外信息，例如：获取声卡更加详细的信息
  
  ```bash
  # inxi -D -x
  Drives:    HDD Total Size: 21.5GB (39.1% used)
             ID-1: /dev/sda model: VMware_Virtual_S size: 21.5GB temp: 0C
  ```
- 20、获取系统安装或更新软件的库的信息，例如：yum、apt等安装或更新软件的库信息
  
  ```bash
  # inxi -r
  Repos:   Active yum sources in file: /etc/yum.repos.d/CentOS7-Base-163.repo
           base ~ http://mirrors.163.com/centos/$releasever/os/$basearch/
           updates ~ http://mirrors.163.com/centos/$releasever/updates/$basearch/
           extras ~ http://mirrors.163.com/centos/$releasever/extras/$basearch/
           Active yum sources in file: /etc/yum.repos.d/epel.repo
           epel ~ https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
  ```
- 21、获取系统本地区的天气预报信息，也可以 -W设置地区查看某个地区的天气情况
  
  ```bash
  # inxi -w
  Weather:   Conditions: 88 F (31 C) - Clear Time: August 14, 3:04 PM CST
  ```
  
  


   
