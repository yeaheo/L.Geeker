## redis 配置主从同步
- 有时候我们安装的 redis 的压力很大，再加上并发高，导致我们读数据和写数据都有了较大的压力。那么我们可能就需要把 redis 分开部署，并且配置为一个成一个[主从]的状态。
- 配置 redis 主从同步需要我们首先安装 redis ，具体安装过程参见 [redis 部署](./redis-installation-gide.md) 

- **redis 集群环境如下：**
  
  ```bash
  master 172.16.6.94
  slave  172.16.6.93
  ```
### 配置 master 节点
- 修改 redis 配置文件 `redis.conf`
- `redis.conf` 默认路径：`/usr/local/redis/redis.conf`
  
  > 我的 redis 安装目录为 `/usr/local/redis`

- 修改 redis 配置文件以下几个参数：
  
  ```bash
  bind 0.0.0.0
  .....
  port 33679
  .....
  daemonize yes
  .....
  logfile "/usr/local/redis/log/redis.log"
  .....
  requirepass CTg-Fls{2018helleo.cn&-93
  .....
  ```
  > 这些参数在 [redis 安装](./redis-installation-gide.md) 部分已经修改过了，在这里只是再提示一下，其实在配置 redis 主从同步的时候， master 节点配置文件几乎不用修改。
  
### 配置 slave 节点
- 修改 redis 配置文件 `redis.conf`
- `redis.conf` 默认路径：`/usr/local/redis/redis.conf`
  > 我的 redis 安装目录为 `/usr/local/redis`

- 修改 redis 配置文件以下几个参数：
  
  ```bash
  bind 0.0.0.0
  .....
  port 33679
  .....
  daemonize yes
  .....
  logfile "/usr/local/redis/log/redis.log"
  .....
  requirepass CTg-Fls{2018helleo.cn&-93
  .....
  slaveof 172.16.6.94 33679              # 配置 redis 主从必须参数
  .....
  masterauth CTg-Fls{2018helleo.cn&-93   # 如果 master 节点配置了密码需要增加该参数，否则不需要增加该参数
  ....
  ```

### 分别启动两个主机的 redis 服务
- 配置完成后，我们需要启动相关服务：
  
  ```bash
  172.16.6.94:
  $ redis-server /usr/local/redis/redis.conf
  172.16.6.93:
  $ redis-server /usr/local/redis/redis.conf
  ```

### 验证 redis 主从
- redis 服务启动之后，我们需要登录到 master 节点的 redis 中查看相关配置：
  
  ```bash
  [root@ctg-fls-web2 ~]# redis-cli -h 172.16.6.94 -p 33679
  172.16.6.94:33679> AUTH CTg-Fls{2018helleo.cn&-93
  OK
  172.16.6.94:33679> info
  ......
  # Replication
  role:master
  connected_slaves:1
  slave0:ip=172.16.6.93,port=33679,state=online,offset=10319,lag=1   # 当输出信息包括如下内容表示 redis 主从配置完成
  ```
  > redis 主从配置完成后，默认是读写分离的，写操作主要在 master 上进行，slave 只能读。

