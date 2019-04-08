## Zookeeper 集群部署
- Apache ZooKeeper是由集群（节点组）使用的一种服务，用于在自身之间协调，并通过稳健的同步技术维护共享数据。ZooKeeper本身是一个分布式应用程序，为写入分布式应用程序提供服务。
- Zookeeper 集群环境：
  
  ```bash
  zookeeper-node-1  172.16.1.40   CentOS7-1704
  zookeeper-node-2  172.16.1.52   CentOS7-1704
  zookeeper-node-3  172.16.1.53   CentOS7-1704
  ```
- 安装前需要关闭三台机器的防火墙及其 selinux 安全机制,三台机器均执行如下命令即可：

  ```bash
  $ systemctl stop firwalld.service && systemctl disable firewalld.service
  
  $ setenforce 0   # 临时关闭，永久关闭需要修改配置文件并重启机器
  ```
### 安装 JDK
- 因为 zookeeper 是基于 java 的应用，所以需要先安装 jdk ，具体安装配置参见 [JDK环境配置](../envconfig/env-java-jdk-config.md)

### 下载 Zookeeper 软件
- Zookeeper 官方下载地址： <http://zookeeper.apache.org/releases.html>
- 我们去官方网站下载最新版本的 `Zookeeper 3.4.12` 版本:
  
  ```bash
  cd /opt/soft
  wget http://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.4.12/zookeeper-3.4.12.tar.gz
  ```
### 安装 Zookeeper 软件
- 我们先配置单机版的 zookeeper ，单机配置完成直接把配置好的相关文件拷贝到集群其他机器上即可。
- 我们本次安装 zookeeper 路径为：`/usr/local/zookeeper-cluster`
- **解压相关软件包到安装路径：**
  
  ```bash
  mkdir /usr/local/zookeeper-cluster
  cd /opt/soft
  tar zxvf zookeeper-3.4.12.tar.gz -C /usr/local/zookeeper-cluster/
  mv zookeeper-3.4.12 zookeeper-node1
  ```
- **准备配置文件**
- 本文档将 zookeeper 的数据文件和日志文件保存在 `/data/zookeeper-cluster/zookeeper-node1` 路径下，这些根据实际情况而定，非必需。
- 准备数据文件和日志文件保存目录：
  
  ```bash
  mkdir -pv /data/zookeeper-cluster/zookeeper-node1/{data,logs}
  ```

- 修改配置文件相关参数:
  
  ```bash
  cd /usr/local/zookeeper-cluster/zookeeper-node1/conf/
  cp zoo_sample.cfg zoo.cfg
  ```
- 修改后完整 `zoo.cfg` 文件参考如下：

  ```bash
  # The number of milliseconds of each tick
  tickTime=2000
  # The number of ticks that the initial 
  # synchronization phase can take
  initLimit=10
  # The number of ticks that can pass between 
  # sending a request and getting an acknowledgement
  syncLimit=5
  # the directory where the snapshot is stored.
  # do not use /tmp for storage, /tmp here is just 
  # example sakes.
  dataDir=/data/zookeeper-cluster/zookeeper-node1/data                   # 定义数据存放位置
  dataLogDir=/data/zookeeper-cluster/zookeeper-node1/logs                # 定义日志存放位置
  # the port at which the clients will connect
  clientPort=2181                                                        # 服务端口
  # the maximum number of client connections.
  # increase this if you need to handle more clients
  #maxClientCnxns=60
  # zookeeper-cluster-servers
  server.1=172.16.1.40:2888:3888     # 集群 server-1
  server.2=172.16.1.52:2888:3888     # 集群 server-2
  server.3=172.16.1.53:2888:3888     # 集群 server-3
  
  # Be sure to read the maintenance section of the 
  # administrator guide before turning on autopurge.
  #
  # http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
  #
  # The number of snapshots to retain in dataDir
  #autopurge.snapRetainCount=3
  # Purge task interval in hours 
  # Set to "0" to disable auto purge feature
  #autopurge.purgeInterval=1
  ```

- 如果在单机上安装伪集群，需要修改 `dataDir`、`dataLogDir` 、`clientPort` 及 `zookeeper-cluster-servers` 等信息为不同值，可以参考如下：
  
  ```bash
  ....
  clientPort=2181  # 不同点
  # zookeeper-cluster-servers
  server.1=172.16.1.40:2887:3887     # 集群 server-1
  server.2=172.16.1.40:2888:3888     # 集群 server-2
  server.3=172.16.1.40:2889:3889     # 集群 server-3
  ```
- **准备 myid 文件**
- 配置文件修改完毕后，需要在数据存放目录新建 myid 文件，具体内容为：`1\2\3`。例如节点1的值就设置为 1 ，其他节点类似，分别为 2、3。
  
  ```bash
  cd /data/zookeeper-cluster/zookeeper-node1/data
  echo "1" > myid
  ```
- 至此，一个节点配置完成，其他节点配置类似，只是某些参数需要修改。

### 启动 Zookeeper 服务
- 配置完成后，我们需要将三台机器上的 zookeeper 全部启动，具体操作如下：
  
  ```bash
  cd /usr/local/zookeeper-cluster/zookeeper-node1/bin
  ./zkServer.sh start
  ```

- 其他节点类似。当三个节点都启动后，需要验证其集群角色：
- **node-1：**
  
  ```bash
  [root@CTSIG-ST bin]# ./zkServer.sh status
  ZooKeeper JMX enabled by default
  Using config: /srv/zookeeper-cluster/zookeeper-node1/bin/../conf/zoo.cfg
  Mode: follower   # 集群角色
  ```
- **node-2:**

  ```bash
  [root@ctsig-doc-server1 bin]# ./zkServer.sh status
  ZooKeeper JMX enabled by default
  Using config: /usr/local/zookeeper-cluster/zookeeper-node2/bin/../conf/zoo.cfg
  Mode: leader     # 集群角色
  ```

- **node-3:**

  ```bash
  [root@ctsig-community-add bin]# ./zkServer.sh status
  ZooKeeper JMX enabled by default
  Using config: /usr/local/zookeeper-cluster/zookeeper-node3/bin/../conf/zoo.cfg
  Mode: follower   # 集群角色
  ```



