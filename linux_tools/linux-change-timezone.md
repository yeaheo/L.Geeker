## Linux 修改时区
- 如果你的 Linux 系统时区配置不正确，必需要手动调整到正确的当地时区。NTP 对时间的同步处理只计算当地时间与 UTC 时间的偏移量，因此配置一个 NTP 对时间进行同步并不能解决时区不正确的问题。

### 查看当前时区
- 可以通过如下命令查看时区：

  ```bash
  [root@docker ~]# date
  Thu May 31 11:08:36 CST 2018
  ```

### 修改时区
- 修改时区一般都是修改整个系统的时区，这里有两种简单的方式来修改时区：

#### 修改 `/etc/profile` 文件

- 修改 `/etc/profile` 文件，增加 `TZ` 变量：
 
  ```bash
  export TZ = 'Asia/Shanghai'
  ```
  
  ```bash
  source /etc/profile
  ```

#### 配置 localtime 文件
- 要更改 Linux 系统整个系统范围的时区可以使用如下命令：

  ```bash
  ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  
  或者直接复制相关文件：
  
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  ```

