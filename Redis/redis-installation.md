## 基于 CentOS 7 安装 redis
- redis 安装其实很简单，本次我是在 centos 7 系统上安装，其他系统安装过程类似，可以参考本文档。
- redis 官方网站：<https://redis.io/>
- redis 下载地址：<https://redis.io/download>

### 下载 redis 软件包
- 首先，需要去官方网站下载最新版 redis 软件包：
  
  ``` bash
  wget http://download.redis.io/releases/redis-4.0.9.tar.gz
  ```
- 其他版本的 redis 也可以通过 [redis 下载页面](https://redis.io/download) 下载。

### 解压并安装 redis 软件包
- 本文档是将 redis 安装在 `/usr/local` 目录下，所以我们将下载的 redis 软件包解压到 `/usr/local` 目录下：
  
  ``` bash
  # tar xf redis-4.0.9.tar.gz -C /usr/local/
  # mv redis-4.0.9 redis
  # cd redis
  # make && make test
  # make install
  ```
  > 当我们在执行 `make test` 的时候，可能会报错，报错原因可能是未安装 tcl 所依赖的包,此时我们需要安装：`yum -y install tcl`，安装完成再执行 `make test`。

### 修改 redis 配置文件
- redis 配置文件默认路径为 `/usr/local/redis/redis.conf` ，我们只需修改该文件即可，不过也可以指定其他路径的 redis 配置文件，只需在 `redis-server` 后跟 redis 的配置文件即可。
- 一般情况下，我们需要修改配置文件的几个位置，具体如下：
  
  ``` bash
  bind 0.0.0.0   # 修改绑定地址,为了方便，这里指定所有地址，默认 127.0.0.1
  .....
  port 33679     # 修改 redis 服务端口，为了安全，我们通常会修改 redis 的服务端口，默认 6379
  .....
  daemonize yes  # 这里将 no 改为 yes，允许后台运行
  .....
  logfile "/usr/local/redis/log/redis.log"  # 指定日志文件
  .....
  requirepass CTg-Fls{2018helleo.cn&-93     # 指定 redis 连接密码
  .....
  ```
- 一般只修改上述几个参数即可，修改完成后就可以启动 redis 服务了。

### 启动 redis 服务
- 一般情况下，我们不用 root 用户启动 redis 服务，为了安全，我们通常情况下使用普通用户启动 redis 服务。

- **新建用户并授权：**
  ``` bash
  useradd -M -s /sbin/nologin redis
  chown -R redis.redis /usr/local/redis/
  ```

- **准备 redis 可执行文件及其日志目录：**
  ``` bash
  mkdir -pv /usr/local/redis/{bin,log}
  cp /usr/local/redis/src/{redis-cli,redis-server} /usr/local/redis/bin
  ln -s /usr/local/redis/bin/* /usr/local/bin
  ```

- **启动 redis 服务**
- 一切工作准备就绪后，就可以启动 redis 服务了：
  ``` bash
  redis-server /usr/local/redis/redis.conf
  ```
- **检验 redis 服务是否成功启动**
  ``` bash
  netstart -antpu | grep redis
  ```
- 如果有如下输出说明 redis 成功启动：
  ``` bash
  tcp    0   0 0.0.0.0:33679   0.0.0.0:*    LISTEN   19194/redis-server
  ```
