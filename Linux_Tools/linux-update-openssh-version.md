## OpenSSH版本升级
- **需要注意的是升级之前先做备份再升级或者配置TELNET服务，避免升级失败导致无法远程连接SSH服务。**
- **[安装配置TELNET](./Linux-配置Telnet后门.md)**

- **检查当前服务器版本**
  ``` bash
  [root@kbweb1 ~]# ssh -V
  OpenSSH_6.6.1p1, OpenSSL 1.0.1e-fips 11 Feb 2013
  ```
- **查看当前已经安装的OpenSSH软件包**
  ``` bash
  [root@kbweb1 ~]# rpm -qa | grep openssh
  openssh-clients-6.6.1p1-25.el7_2.x86_64
  openssh-6.6.1p1-25.el7_2.x86_64
  openssh-server-6.6.1p1-25.el7_2.x86_64
  ```
- **安装编译环境**
  ``` bash
  yum install zlib-devel openssl-devel gcc gcc-c++ make -y
  ```
- **编译新版本的OpenSSH版本**
- OpenSSH官方网站: <http://www.openssh.com/>
- 下载最新版本的安装包
  ``` bash
  wget https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.6p1.tar.gz
  ```
- 解压并编译安装包
  ``` bash
  tar xf openssh-7.6p1.tar.gz -C /usr/src
  cd /usr/src/openssh-7.6p1
  ./configure --prefix=/usr/local/openssh
  make
  ```
- **安装并配置新版本的OpenSSH**
- 在这里需要先卸载旧版本的OpenSSH
  ``` bash
  rpm -e --nodeps `rpm -qa | grep openssh`
  ```
- 安装新版本的OpenSSH，之前我们已经编译好了，直接安装即可
  ``` bash
  cd /usr/src/openssh-7.6p1
  make install
  ```
- 复制启动脚本文件
  ``` bash
  cp /usr/src/openssh-7.6p1/contrib/redhat/sshd.init /etc/init.d/sshd
  chkconfig --add sshd
  ```
- 复制执行文件
  ``` bash
  cp /usr/local/openssh/sbin/sshd  /usr/sbin/sshd
  cp /usr/local/openssh/bin/ssh /usr/bin/
  cp /usr/local/openssh/bin/ssh-keygen /usr/bin/
  ```
- 配置允许root用户远程登录
  ``` bash
  vim /usr/local/openssh/etc/sshd_config
  修改如下内容： 
  32 #LoginGraceTime 2m
  33 PermitRootLogin yes   # 将PermitRootLogin改为yes并取消注释
  34 #StrictModes yes
  35 #MaxAuthTries 6
  36 #MaxSessions 10
  ```
- **重启SSHD服务并检测SSH版本**
  ``` bash
  [root@lv-achieve ~]# service sshd restart
  Restarting sshd (via systemctl):                           [  OK  ]
  
  [root@lv-achieve ~]# ssh -V
  OpenSSH_7.6p1, OpenSSL 1.0.2k-fips  26 Jan 2017
  ```
- 至此升级完成，需要注意的是升级之前需要先备份好旧的文件或者配置TELNET服务，避免升级失败导致无法远程连接SSH服务。
- 如果先前配置了TELNET服务，需要做的是在检查安装是否完毕后卸载TELNET服务，并去掉配置TELNET时的注释
  ``` bash
  yum -y remove telnet-server xinetd telnet
  ```
  


