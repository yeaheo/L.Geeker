### Ceph集群快速部署方案
- 在正式部署之前需要先做完预检方面的工作，参见[ceph预检](Ceph安装前的准备工作.md)
- 这次部署我们选用一个管理节点和三个MON节点、三个OSD节点，一旦集群达到 active + clean 状态，还可以扩展：增加OSD节点、增加元数据服务器或者增加MON节点。

- 为获得最佳体验，先在管理节点上创建一个目录，用于保存 ceph-deploy 生成的配置文件和密钥对。
  - `mkdir /ceph-cluster`
  - `cd /ceph-cluster`
- ceph-deploy 会把文件输出到当前目录，所以请确保在此目录下执行 ceph-deploy 
- Important:
  - 如果你是用另一普通用户登录的，不要用 sudo 或在 root 身份运行 ceph-deploy ，因为它不会在远程主机上调用所需的 sudo 命令。

#### 禁用 requiretty
- 在某些发行版（如 CentOS ）上，执行 ceph-deploy 命令时，如果你的 Ceph 节点默认设置了 requiretty 那就会遇到报错。可以这样禁用此功能：执行 sudo visudo ，找到 Defaults requiretty 选项，把它改为 Defaults:ceph !requiretty ，这样 ceph-deploy 就能用 ceph 用户登录并使用 sudo 了。

#### 清除集群配置方法
- 如果在某些地方碰到麻烦，想从头再来，可以用下列命令清除配置：
  - `ceph-deploy purgedata {ceph-node} [{ceph-node}]`
  - `ceph-deploy forgetkeys`
- 用下列命令可以连 Ceph 安装包一起清除：
  - `ceph-deploy purge {ceph-node} [{ceph-node}]`
- 如果执行了 `purge` ，你必须重新安装 Ceph

#### 正式部署Ceph集群
- 在管理节点上，进入刚创建的放置配置文件的目录，用 ceph-deploy 执行如下步骤。

#### 创建集群
- `ceph-deploy new {initial-monitor-node(s)}`
- 例：
- `ceph-deploy new ceph-n2 ceph-n3 ceph-n4`  
- 此方法是建立三个MON节点
- 在当前目录下用 ls 和 cat 检查 ceph-deploy 的输出，应该有一个 Ceph 配置文件、一个 monitor 密钥环和一个日志文件。
- 需要注意的是ceph配置文件内默认的副本数为`3`，如果想要只有两个OSD节点的ceph集群达到active+clean的状态，可以修改ceph配置文件`ceph.conf`,在[global]段添加如下内容：
  - `osd pool default size = 2`

#### 安装Ceph
- `ceph-deploy install {ceph-node} [{ceph-node} ...]`
- 例如：
- `ceph-deploy install ceph-n1 ceph-n2 ceph-n3 ceph-n4`
- ceph-deploy 将在各节点安装 Ceph 。 注：如果你执行过 ceph-deploy purge ，你必须重新执行这一步来安装 Ceph 。

#### 配置初始 monitor(s)、并收集所有密钥：
- `ceph-deploy mon create-initial`
- 完成上述操作后，当前目录里应该会出现这些密钥环：
  ``` xml
  -rw------- 1 root root    113 8月  21 14:28 ceph.bootstrap-mds.keyring
  -rw------- 1 root root     71 8月  21 14:28 ceph.bootstrap-mgr.keyring
  -rw------- 1 root root    113 8月  21 14:28 ceph.bootstrap-osd.keyring
  -rw------- 1 root root    113 8月  21 14:28 ceph.bootstrap-rgw.keyring
  -rw------- 1 root root    129 8月  21 14:28 ceph.client.admin.keyring
  -rw-r--r-- 1 root root    227 8月  21 14:08 ceph.conf
  -rw-r--r-- 1 root root 302104 8月  21 15:03 ceph-deploy-ceph.log
  -rw------- 1 root root     73 8月  21 14:08 ceph.mon.keyring
  ```
#### 添加三个OSD
- 为了快速地安装，这篇快速入门把目录而非整个硬盘用于 OSD 守护进程。如何为 OSD 及其日志使用独立硬盘或分区
- 登录到 Ceph 节点、并给 OSD 守护进程创建一个目录。
  ``` xml
  ssh ceph-n2
  sudo mkdir -pv /cephwork/local/osd0
  exit
  
  ssh ceph-n3
  sudo mkdir -pv /cephwork/local/osd1
  exit

  ssh ceph-n4
  sudo mkdir -pv /cephwork/local/osd2
  exit
  ```
- 然后，从管理节点执行 ceph-deploy 来准备 OSD 。
  - `ceph-deploy osd prepare {ceph-node}:/path/to/directory`
  - 例如:
  - `ceph-deploy osd prepare ceph-n2:/cephwork/local/osd0 ceph-n3:/cephwork/local/osd1 ceph-n4:/cephwork/local/osd2`
- 最后，激活 OSD 
  - `ceph-deploy osd activate {ceph-node}:/path/to/directory`
  - 例如：
  - `ceph-deploy osd activate ceph-n2:/cephwork/local/osd0 ceph-n3:/cephwork/local/osd1 ceph-n4:/cephwork/local/osd2`
- 用 ceph-deploy 把配置文件和 admin 密钥拷贝到管理节点和 Ceph 节点，这样你每次执行 Ceph 命令行时就无需指定 monitor 地址和 ceph.client.admin.keyring 了
  - `ceph-deploy admin ceph-n1 ceph-n2 ceph-n3 ceph-n4`

- 确保你对 ceph.client.admin.keyring 有正确的操作权限
  - `chmod +r /etc/ceph/ceph.client.admin.keyring`

- 检查集群的健康状况。
  - `ceph health`
#### 至此整个ceph集群部署完成，此集群包含三个MON和三个OSD，其他的角色后续再添加。

