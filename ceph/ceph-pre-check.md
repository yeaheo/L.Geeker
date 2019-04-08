## Ceph 安装前的准备工作——预检
- 建议安装一个 ceph-deploy 管理节点和一个三节点的 Ceph 存储集群来研究 Ceph 的基本特性。这篇预检会帮你准备一个 `ceph-deploy` 管理节点、以及三个 Ceph 节点（或虚拟机），以此构成 Ceph 存储集群。在进行下一步之前，请参见操作系统推荐以确认你安装了合适的 Linux 发行版。如果你在整个生产集群中只部署了单一 Linux 发行版的同一版本，那么在排查生产环境中遇到的问题时就会容易一点。
- 基本架构图参见下图:
- ![ceph基本架构图](../images/ceph1.png)

### 安装 Ceph 部署工具
- 把 Ceph 仓库添加到 `ceph-deploy` 管理节点，然后安装 `ceph-deploy` 。
- Ceph安装版本可参见 ： <http://download.ceph.com>，这里我选用 `rpm-jewel` 这个版本作为参考。
- 具体安装方式如下：
  
  ```bash
  rpm -Uvh http://download.ceph.com/rpm-jewel/el7/noarch/ceph-release-1-1.el7.noarch.rpm
  yum clean all && yum makecache
  yum -y update
  yum -y install ceph-deploy
  ```

- 创建一个 ceph 工作目录，以后的操作都在这个目录下面进行：
  
  ```bash
  mkdir /ceph-cluster
  cd /ceph-cluster
  ```

### 允许无密码 SSH 登录
- 正因为 `ceph-deploy` 不支持输入密码，你必须在管理节点上生成 SSH 密钥并把其公钥分发到各 Ceph 节点。 `ceph-deploy` 会尝试给初始 `monitors` 生成 SSH 密钥对。
- 具体操作如下表述：
- 首先，在管理节点上执行 `ssh-keygen`，然后一路回车即可。
- 把公钥拷贝到各 Ceph 节点，把下列命令中的 {username} 替换成前面创建部署 Ceph 的用户里的用户名。
  
  ```bash
  ssh-copy-id {username}@node1
  ssh-copy-id {username}@node2
  ssh-copy-id {username}@node3
  ```
- 登陆 ceph 各个节点进行测试，看是否实现无密码 SSH 登陆。
- 另外，还有一种方法可以尝试：
- 修改 ceph-deploy 管理节点上的 `~/.ssh/config` 文件,这样ceph-deploy就能用你所建的用户名登陆各个ceph节点了。
- 具体格式如下：
  
  ```bash
  Host node1
  Hostname node1
  User {username}
  Host node2
  Hostname node2
  User {username}
  Host node3
  Hostname node3
  User {username}
  ```

### 各个Ceph节点引导时需要联网
- 因为要通过网络获取所需软件包，所以需要联网，进行相关下载。
- Ceph 的各 OSD 进程通过网络互联并向 Monitors 上报自己的状态。如果网络默认为 off ，那么 Ceph 集群在启动时就不能上线，直到你打开网络。

### 开放所需端口
- Ceph Monitors 之间默认使用 6789 端口通信， OSD 之间默认用 6800:7300 这个范围内的端口通信。
- Ceph OSD 能利用多个网络连接进行与客户端、monitors、其他 OSD 间的复制和心跳的通信。
- 对于 RHEL 7 上的 firewalld ，要对公共域开放 Ceph Monitors 使用的 6789 端口和 OSD 使用的 6800:7300 端口范围，并且要配置为永久规则，这样重启后规则仍有效。例如：
- 规则参考：
  
  ```bash
  sudo firewall-cmd --zone=public --add-port=6789/tcp --permanent
  ```
- 若使用 iptables ，要开放 Ceph Monitors 使用的 6789 端口和 OSD 使用的 6800:7300 端口范围，命令如下：

  ```bash
  sudo iptables -A INPUT -i {iface} -p tcp -s {ip-address}/{netmask} --dport 6789 -j ACCEPT
  ```

- 在每个节点上配置好 iptables 之后要一定要保存，这样重启之后才依然有效。例如
  
  ```bash
  /sbin/service iptables save
  ```

### 终端（ TTY ）
- 在 CentOS 和 RHEL 上执行 ceph-deploy 命令时可能会报错。
- 如果你的 Ceph 节点默认设置了 requiretty ，执行 sudo visudo 禁用它，并找到 Defaults requiretty 选项，把它改为 Defaults:ceph !requiretty 或者直接注释掉，这样 ceph-deploy 就可以用之前创建的用户

### SELINUX 安全机制
- 在 CentOS 和 RHEL 上， SELinux 默认为 Enforcing 开启状态。
- 为简化安装，我们建议把 SELinux 设置为 Permissive 或者完全禁用，也就是在加固系统配置前先确保集群的安装、配置没问题。用下列命令把 SELinux 设置为 Permissive ：
  
  ```bash
  setenforce 0
  ```

- 要使 SELinux 配置永久生效（如果它的确是问题根源），需修改其配置文件 `/etc/selinux/config`

### 优先级/首选项
- 确保你的包管理器安装了优先级/首选项包且已启用。在 CentOS 上你也许得安装 EPEL ，在 RHEL 上你也许得启用可选软件库。
  
  ```bash
  yum install yum-plugin-priorities -y
  ```
- 比如在 RHEL 7 服务器上，可用下列命令安装 yum-plugin-priorities并启用 rhel-7-server-optional-rpms 软件库：
  
  ```bash
  yum -y install yum-plugin-priorities --enablerepo=rhel-7-server-optional-rpms
  ```

- 至此，预检结束，接下来就可以安装 ceph 集群了。


   
