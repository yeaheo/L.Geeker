## 基于 CentOS 7 安装配置 OpenVPN
- **OpenVPN** 是一个用于创建虚拟专用网络加密通道的软件包，最早由 James Yonan 编写。OpenVPN 允许创建的 VPN 使用公开密钥、电子证书、或者用户名/密码来进行身份验证。
- 它大量使用了 OpenSSL 加密库中的 SSLv3/TLSv1 协议函数库。
- 目前 OpenVPN 能在 Solaris、Linux、OpenBSD、FreeBSD、NetBSD、Mac OS X 与 Microsoft Windows 以及 Android 和 iOS 上运行，并包含了许多安全性的功能。它并不是一个基于 Web 的 VPN 软件，也不与 IPsec 及其他 VPN 软件包兼容。
- OpenVPN 的技术核心是虚拟网卡，其次是 SSL 协议实现。



### 安装环境及版本信息：
- 安装环境：

  ```bash
  # cat /etc/redhat-release 
  CentOS Linux release 7.5.1804 (Core) 
  ```

### 安装 easy-rsa 并生成相关证书
- easy-rsa 下载地址：<https://codeload.github.com/OpenVPN/easy-rsa-old/zip/master>
- 下载并解压 easy-rsa 软件包：

  ```bash
  cd /opt/soft
  wget https://codeload.github.com/OpenVPN/easy-rsa-old/zip/master
  mv master easy-rsa-old-master.zip
  unzip -d /usr/local/ easy-rsa-old-master.zip
  ```
  
- 生成相关证书：
- 解压软件包后，切换到 `easy-rsa-old-master/easy-rsa/2.0/` ，这里都是一些可执行文件，具体内容如下：

  ```bash
  cd /usr/local/easy-rsa-old-master/easy-rsa/2.0/
  [root@test-node-2 2.0]# ll
  total 116
  -rwxr-xr-x. 1 root root   119 Jan 23 14:46 build-ca
  -rwxr-xr-x. 1 root root   361 Jan 23 14:46 build-dh
  -rwxr-xr-x. 1 root root   188 Jan 23 14:46 build-inter
  -rwxr-xr-x. 1 root root   163 Jan 23 14:46 build-key
  -rwxr-xr-x. 1 root root   157 Jan 23 14:46 build-key-pass
  -rwxr-xr-x. 1 root root   249 Jan 23 14:46 build-key-pkcs12
  -rwxr-xr-x. 1 root root   268 Jan 23 14:46 build-key-server
  -rwxr-xr-x. 1 root root   213 Jan 23 14:46 build-req
  -rwxr-xr-x. 1 root root   158 Jan 23 14:46 build-req-pass
  -rwxr-xr-x. 1 root root   428 Jan 23 14:46 clean-all
  -rwxr-xr-x. 1 root root  1457 Jan 23 14:46 inherit-inter
  drwx------. 2 root root  4096 Jun  3 03:58 keys
  -rwxr-xr-x. 1 root root   295 Jan 23 14:46 list-crl
  -rw-r--r--. 1 root root  7771 Jan 23 14:46 openssl-0.9.6.cnf
  -rw-r--r--. 1 root root  8328 Jan 23 14:46 openssl-0.9.8.cnf
  -rw-r--r--. 1 root root  8225 Jan 23 14:46 openssl-1.0.0.cnf
  lrwxrwxrwx. 1 root root    17 Jun  3 03:53 openssl.cnf -> openssl-1.0.0.cnf   # 该文件是后期生成的
  -rwxr-xr-x. 1 root root 12660 Jan 23 14:46 pkitool
  -rwxr-xr-x. 1 root root   918 Jan 23 14:46 revoke-full
  -rwxr-xr-x. 1 root root   178 Jan 23 14:46 sign-req
  -rw-r--r--. 1 root root  1857 Jun  3 03:54 vars
  -rwxr-xr-x. 1 root root   714 Jan 23 14:46 whichopensslcnf
  ```

- 准备 openssl 相关文件

  ```bash
  [root@test-node-2 2.0]# pwd
  /usr/local/easy-rsa-old-master/easy-rsa/2.0
  [root@test-node-2 2.0]# ln -s openssl-1.0.0.cnf openssl.cnf
  ```

- 可修改 vars 文件中定义的变量用于生成证书的基本信息，以下是我的信息:

  ```bash
  ...
  export KEY_COUNTRY="CN"
  export KEY_PROVINCE="BJ"
  export KEY_CITY="BEIJING"
  export KEY_ORG="CTSIG"
  export KEY_EMAIL="lvxiaoteng"
  export KEY_EMAIL=mail@host.domain
  export KEY_CN=changeme
  export KEY_NAME=changeme
  export KEY_OU=changeme
  export PKCS11_MODULE_PATH=changeme
  export PKCS11_PIN=1234
  ...
  ```

- 生成证书：

  ```bash
  [root@test-node-2 2.0]# pwd
  /usr/local/easy-rsa-old-master/easy-rsa/2.0
  

  source vars
  ./clean-all
  ./build-ca
  ```

- 因为已经在 var 中填写了证书的基本信息，所以一路回车即可。生成证书如下：

  ```bash
  [root@test-node-2 2.0]# ls keys/
  ca.crt  ca.key  index.txt  serial
  ```
- 生成服务器端秘钥：

  ```bash
  ./build-key-server server
  ......
  Common Name (eg, your name or your server's hostname) [server]:
  A challenge password []:
  ......

  # 一路回车即可，最后有两次确认，输入 "y" 再按回车即可。
  ```

- 查看生成的密钥：

  ```bash
  [root@test-node-2 2.0]# ls keys
  01.pem  ca.crt  ca.key  index.txt  index.txt.attr  index.txt.old  serial  serial.old  server.crt  server.csr  server.key
  ```

- 生成客户端证书：

  ```bash
  ./build-key client
  ......
  Common Name (eg, your name or your server's hostname) [client]:
  A challenge password []:1234
  ......

  # 一路回车即可，最后有两次确认，输入 "y" 再按回车即可。
  ```

  > Common Name 用于区分客户端，不同的客户端应该有不同的名称，当我们需要新建用户的时候可以参考上面。

- 生成 Diffie Hellman 参数：

  ```bash
  ./build-dh
  ```

- 证书生成完毕，查看生成的所有证书：
  
  ```bash
  [root@test-node-2 2.0]# ls keys
  01.pem  02.pem  ca.crt  ca.key  client.crt  client.csr  client.key  dh2048.pem  index.txt  index.txt.attr  index.txt.attr.old  index.txt.old  serial  serial.old  server.crt  server.csr  server.key
  ```

### 编译安装 OpenVPN
- OpenVPN 下载地址：<https://swupdate.openvpn.org/community/releases/openvpn-2.4.4.tar.gz>
- 下载 OpenVPN 软件包：

  ```bash
  cd /opt/soft
  wget https://swupdate.openvpn.org/community/releases/openvpn-2.4.4.tar.gz
  ```

- 安装依赖包：

  ```bash
  yum install -y lzo lzo-devel openssl openssl-devel pam pam-devel net-tools git lz4-devel
  ```

- 安装 OpenVPN

  ```bash
  tar xf /opt/soft/openvpn-2.4.4.tar.gz -C /usr/src/
  cd /usr/src/openvpn-2.4.4
  ./configure --prefix=/usr/local/openvpn
  make
  make install
  ```

  > 编译安装的时候可能还会遇到错误，当出现报错的时候根据报错信息提示排除错误即可。

### 配置 OpenVPN 服务端
- 创建配置文件目录和证书目录：

  ```bash
  mkdir -p /etc/openvpn        # openvpn 配置文件路径
  mkdir -p /etc/openvpn/pki    # openvpn 证书存放位置
  ```

- 生成 tls-auth key 并将其拷贝到证书目录中：

  ```bash
  /usr/local/openvpn/sbin/openvpn --genkey --secret ta.key
  mv ./ta.key /etc/openvpn/pki
  ```

- 将签名生成的 CA 证书秘钥和服务端证书秘钥拷贝到证书目录中：

  ```bash
  cp /usr/local/easy-rsa-old-master/easy-rsa/2.0/keys/{ca.key,ca.crt,server.crt,server.key,dh2048.pem} /etc/openvpn/pki/

  ls /etc/openvpn/pki/
  ca.crt  ca.key  dh2048.pem  server.crt  server.key  ta.key
  ```

- 将 OpenVPN 源码下的配置文件 `sample/sample-config-files/server.conf` 拷贝到 `/etc/openvpn` 目录：

  ```bash
  cp /usr/src/openvpn-2.4.4/sample/sample-config-files/server.conf /etc/openvpn/
  ```

- 编辑服务端配置文件 `/etc/openvpn/server.conf`：

  ```conf
  
  port 1194
  proto tcp
  dev tun
  
  ca /etc/openvpn/pki/ca.crt
  cert /etc/openvpn/pki/server.crt
  key /etc/openvpn/pki/server.key  # This file should be kept secret
  dh /etc/openvpn/pki/dh2048.pem
  
  server 10.8.0.0 255.255.255.0    # 分配给客户端的虚拟局域网段
  
  ifconfig-pool-persist ipp.txt
  
  push "route 10.0.0.0 255.0.0.0"  # 推送路由和DNS到客户端
  
  client-to-client
  keepalive 10 120
  
  tls-auth /etc/openvpn/pki/ta.key 0 # This file is secret
  cipher AES-256-CBC
  comp-lzo
  max-clients 50
  
  user nobody
  group nobody
  
  persist-key
  persist-tun
  
  status /var/log/openvpn-status.log
  log         /var/log/openvpn.log
  log-append  /var/log/openvpn.log
  
  verb 3
  
  # plugin /usr/lib64/openvpn/plugin/lib/openvpn-auth-ldap.so "/etc/openvpn/auth/ldap.conf cn=*" 
  # client-cert-not-required
  ```

- 开启内核路由转发功能:

  ```bash
  vim /etc/sysctl.conf
  
  添加如下内容

  net.ipv4.ip_forward = 1

  sysctl -p
  ```

- 配置 iptables 策略：

  ```bash
  iptables -P FORWARD ACCEPT
  iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE
  ```

  > 也可以这样做：添加 iptables 转发规则，对所有源地址（openvpn为客户端分配的地址）为 10.8.0.0/24 的数据包转发后进行源地址转换，伪装成 openvpn 服务器内网地址 xx.x.x.x， 这样 VPN 客户端就可以访问服务器内网的其他机器了。


- 创建 openvpn 的 systemd unit 文件：

  ```bash
  [root@test-node-2 keys]# cat /usr/lib/systemd/system/openvpn.service 

  [Unit]
  Description=openvpn
  After=network.target
  
  [Service]
  EnvironmentFile=-/etc/openvpn/openvpn
  ExecStart=/usr/local/openvpn/sbin/openvpn        --config /etc/openvpn/server.conf
  Restart=on-failure
  Type=simple
  LimitNOFILE=65536
  
  [Install]
  WantedBy=multi-user.target
  ```

- 启动并设置为开机启动：

  ```bash
  systemctl start openvpn.service
  systemctl enable openvpn.service
  ```

  > 如果服务启动报错，可以根据报错提示排除错误

- 查看端口监听：

  ```bash
  [root@test-node-2 keys]# netstat -antpu | grep openvpn
  tcp        0      0 0.0.0.0:1194            0.0.0.0:*               LISTEN      60393/openvpn       
  tcp        0      0 192.168.31.111:1194     192.168.31.62:55559     ESTABLISHED 60393/openvpn   # 有一个连接
  ```

- 至此，OpenVPN 服务端安装并配置完成，下一步就是用客户端进行连接测试了，具体测试过程参见 [OpenVPN 连接测试](./openvpn-client-test.md)

- **参考文档：**

- <https://openvpn.net/index.php/open-source/documentation/install.html>



