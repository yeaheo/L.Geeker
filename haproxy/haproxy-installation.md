## Haproxy 的安装配置
- 这里我们采用源码的方式安装Haproxy
- Haproxy 的官方网站地址: <http://www.haproxy.org>
- Haproxy 的官方下载地址: <http://www.haproxy.org/download/>

### Haproxy 安装
- **安装依赖包**
  
  ```bash
  yum install gcc gcc-c++ make wget openssl-devel kernel-devel
  ```

- **下载 Haproxy 安装包**
  
  ```bash
  wget http://www.haproxy.org/download/1.6/src/haproxy-1.6.13.tar.gz
  # 具体安装步骤：
  tar -zvxf haproxy-1.6.13.tar.gz`
  cd haproxy-1.6.13`
  make TARGET=linux2628 CPU=x86_64 PREFIX=/usr/local/haprpxy USE_OPENSSL=1 ADDLIB=-lz
  ```

- 参数说明：
- `TARGET=linux2628` 使用 uname -r 查看内核，如：2.6.32-642.el6.x86_64，此时该参数就为linux26.如：3.10.0-514.26.2.el7.x86_64，此时该参数为linux2628
- `CPU=x86_64` 使用 uname -r 查看系统信息，如 x86_64 GNU/Linux，此时该参数就为 x86_64
- `PREFIX=/usr/local/haprpxy` 安装目录
- `USE_OPENSSL=1 ADDLIB=-lz` 支持SSL
- `ldd haproxy | grep ssl`
- `make install PREFIX=/usr/local/haproxy`

### 安装完成需要做一些基本配置
- 配置文件：
  
  ```bash
  mkdir -p /usr/local/haproxy/conf
  mkdir -p /etc/haproxy
  cp /usr/local/src/haproxy-1.6.13/examples/option-http_proxy.cfg /usr/local/haproxy/conf/haproxy.cfg
  ln -s /usr/local/haproxy/conf/haproxy.cfg /etc/haproxy/haproxy.cfg
  cp -r /usr/local/src/haproxy-1.6.13/examples/errorfiles  /usr/local/haproxy/errorfiles
  ln -s /usr/local/haproxy/errorfiles /etc/haproxy/errorfiles
  ```

- 日志目录：
  
  ```bash
  mkdir -p /usr/local/haproxy/log
  touch /usr/local/haproxy/log/haproxy.log
  ln -s /usr/local/haproxy/log/haproxy.log /var/log/haproxy.log
  ```

- 添加为系统服务
  
  ```bash
  cp /usr/local/src/haproxy-1.6.13/examples/haproxy.init /etc/rc.d/init.d/haproxy
  chmod +x /etc/rc.d/init.d/haproxy
  chkconfig --add haproxy
  chkconfig haproxy on
  chkconfig --list haproxy
  ln -s /usr/local/haproxy/sbin/haproxy /usr/sbin
  ```

- 编写配置文件
  
  ```bash
  cp /usr/local/haproxy/conf/haproxy.cfg /usr/local/haproxy/conf/haproxy.cfg.bak
  vim /usr/local/haproxy/conf/haproxy.cfg
  ```
  
- [配置文件模板](haproxy.cfg.md)

- 启动服务
  
  ```bash
  systemctl start haproxy.service
  ```

- 设置Haproxy日志
  ```bash
  vim /etc/rsyslog.conf
  ```

  ```bash
  .......
  $ModLoad imudp                       #取消注释 ，这一行不注释，日志就不会写
  $UDPServerRun 514                    #取消注释 ，这一行不注释，日志就不会写
  .......
  local0.*                                                /var/log/haproxy.log      #这一行可以没有，可以不用写
  local3.*                                                /var/log/haproxy.log      #这一行必须要写
  ```
  
  ```bash
  vim /etc/sysconfig/rsyslog
  ```

  ```bash
  SYSLOGD_OPTIONS="-r -m 0"           #接收远程服务器日志
  ```
  
  ```bash
  systemctl restart rsyslog
  ```
- Haproxy+Keepalived 架构会更完美，实现负载均衡和高可用。
