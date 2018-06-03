## 基于 CentOS 7 安装配置 OpenVPN
- **OpenVPN** 是一个用于创建虚拟专用网络加密通道的软件包，最早由 James Yonan 编写。OpenVPN 允许创建的 VPN 使用公开密钥、电子证书、或者用户名/密码来进行身份验证。
- 它大量使用了 OpenSSL 加密库中的 SSLv3/TLSv1 协议函数库。
- 目前 OpenVPN 能在 Solaris、Linux、OpenBSD、FreeBSD、NetBSD、Mac OS X 与 Microsoft Windows 以及 Android 和 iOS 上运行，并包含了许多安全性的功能。它并不是一个基于 Web 的 VPN 软件，也不与 IPsec 及其他 VPN 软件包兼容。
- OpenVPN 的技术核心是虚拟网卡，其次是 SSL 协议实现。

### 安装 OpenVPN

#### 安装环境及版本信息：
- 安装环境：

  ```bash
  # cat /etc/redhat-release 
  CentOS Linux release 7.5.1804 (Core) 
  ```

#### 安装 easy-rsa 并生成相关证书
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


  
