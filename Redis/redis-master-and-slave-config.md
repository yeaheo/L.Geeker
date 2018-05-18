## redis 配置主从同步
- 有时候我们安装的 redis 的压力很大，再加上并发高，导致我们读数据和写数据都有了较大的压力。那么我们可能就需要把 redis 分开部署，并且配置为一个成一个[主从]的状态。
- 配置 redis 主从同步需要我们首先安装 redis ，具体安装过程参见 [redis 部署](./redis-installation.md) 

- **redis 集群环境如下：**
  ``` bash
  master 172.16.6.94
  slave  172.16.6.93
  ```
  
