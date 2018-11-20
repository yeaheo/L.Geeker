## Linux 系统安装配置 RabbitMQ 集群

一般情况下，如果只是为了探究 RabbitMQ 或者验证业务工程的正确性那么在本地环境或者测试环境上使用其单实例部署就可以了，但是出于 MQ 中间件本身的可靠性、并发性、吞吐量和消息堆积能力等问题的考虑，在生产环境上一般都会考虑使用 RabbitMQ 的集群方案。

本文档旨在介绍 RabbitMQ 集群的工作原理以及在 CentOS 7 系统上安装配置具备高可用性和具备一定负载能力的 RabbitMQ 集群。

### RabbitMQ 集群工作原理介绍

RabbitMQ 这款消息队列中间件产品本身是基于 Erlang 编写，Erlang 语言天生具备分布式特性（通过同步 Erlang 集群各节点的 magic cookie 来实现）。因此，RabbitMQ 天然支持 Clustering。这使得 RabbitMQ 本身不需要像ActiveMQ、Kafka 那样通过 ZooKeeper 分别来实现 HA 方案和保存集群的元数据。集群是保证可靠性的一种方式，同时可以通过水平扩展以达到增加消息吞吐量能力的目的。

RabbitMQ 集群有两种模式：

- **默认模式**，以两个节点 mq1 和 mq2 为例来进行说明。对于 Queue 来说，消息实体只存在于其中一个节点 mq1 或者 mq2 ，mq1 和 mq2 两个节点仅有相同的元数据，即队列的结构。当消息进入 mq1 节点的 Queue 后，consumer 从 mq2 节点消费时，RabbitMQ 会临时在 mq1 、mq2 间进行消息传输，把 A 中的消息实体取出并经过 B 发送给 consumer。所以 consumer 应尽量连接每一个节点，从中取消息。即对于同一个逻辑队列，要在多个节点建立物理 Queue。否则无论 consumer 连 mq1 或 mq2 ，出口总在 mq1，会产生瓶颈。当 mq1 节点故障后，mq2 节点无法取到 mq1 节点中还未消费的消息实体。如果做了消息持久化，那么得等 mq1 节点恢复，然后才可被消费；如果没有持久化的话，就会产生消息丢失的现象。
- **镜像模式**，把需要的队列做成镜像队列，存在与多个节点属于**RabbitMQ 的 HA 方案。**该模式解决了普通模式中的问题，其实质和普通模式不同之处在于，消息实体会主动在镜像节点间同步，而不是在客户端取数据时临时拉取。该模式带来的副作用也很明显，除了降低系统性能外，如果镜像队列数量过多，加之大量的消息进入，集群内部的网络带宽将会被这种同步通讯大大消耗掉。所以在对可靠性要求较高的场合中适用。

### RabbitMQ 集群部署

RabbitMQ 集群主机环境如下：

```bash
mq-node1(master)  10.200.100.231 master.yeaheo.com
mq-node2(node01)  10.200.100.231 node01.yeaheo.com
mq-node3(node02)  10.200.100.231 node02.yeaheo.com
```

各主机系统环境及 MQ 版本如下：

```bash
$ cat /etc/redhat-release
CentOS Linux release 7.5.1804 (Core)

$ uname -r
3.10.0-862.el7.x86_64

Erlang : 21.1
RabbitMQ: v3.7.9
```

修改各主机 `hosts` 文件如下：

```bash
....
10.200.100.231 master master.yeaheo.com
10.200.100.217 node01 node01.yeaheo.com
10.200.100.218 node02 node02.yeaheo.com
....
```

配置 RabbitMQ 集群首先需要在各个主机上安装并配置 Erlang 和 RabbitMQ ，Erlang安装过程可以参考: [rabbitmq-erlang-installation.md ](https://github.com/yeaheo/hello-linux/blob/master/rabbitmq/rabbitmq-erlang-installation.md)RabbitMQ 具体过程可以参考：[rabbitmq-single-installation.md](https://github.com/yeaheo/hello-linux/blob/master/rabbitmq/rabbitmq-single-installation.md)

当 Erlang 和 RabbitMQ 安装完成后就可以配置 RabbitMQ 集群了。

### 配置 RabbitMQ 集群

本次部署集群时都是将其他两个 RabbitMQ 加入到 master 主机现有集群中。

rabbitmq-server 启动时，会一起启动节点和应用，它预先设置 RabbitMQ 应用为 standalone 模式。要将一个节点加入到现有的集群中，你需要停止这个应用，并将节点设置为原始状态。如果使用 `rabbitmqctl stop`，应用和节点都将被关闭。所以使用 `rabbitmqctl stop_app`仅仅关闭应用

因为将其他两个 RabbitMQ 加入到 master 主机现有集群中，所以只需要在 `node01`和 `node02` 上操作即可：

node01 主机（10.200.100.217）上操作：

```bash
node01$ rabbitmqctl stop_app      
node01$ rabbitmqctl join_cluster rabbit@master         ####这里集群的名字一定不要写错了
node01$ rabbitmqctl start_app
```

> 集群名字一般可以在 `master`主机的日志文件中看到，需要注意的是这个集群名字需要和日志文件中保持一致，否则加入集群时会报错

node02 主机（10.200.100.218）上操作：

```bash
node02$ rabbitmqctl stop_app      
node02$ rabbitmqctl join_cluster rabbit@master         ####这里集群的名字一定不要写错了
node02$ rabbitmqctl start_app
```

查看集群状态：

```bash
$ rabbitmqctl cluster_status
```



此时 `node01` 与 `node02` 也会自动建立连接，集群配置完成。

> 如果要使用内存节点，则可以使用 `rabbitmqctl join_cluster --ram rabbit@master` 加入集群。

