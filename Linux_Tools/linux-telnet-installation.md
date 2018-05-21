## Linux 配置 Telnet 后门
- Telnet 命令一般用于远程登录。 Telnet 程序是基于 TELNET 协议的远程登录客户端程序，Telnet 协议是 TCP/IP 协议族中的一员，是 Internet 远程登陆服务的标准协议和主要方式。
- 它为用户提供了在本地计算机上完成远程主机工作的能力。在终端使用者的电脑上使用 telnet 程序，用它连接到服务器。终端使用者可以在 telnet 程序中输入命令，这些命令会在服务器上运行，就像直接在服务器的控制台上输入一样。可以在本地就能控制服务器。要开始一个 telnet 会话，必须输入用户名和密码来登录服务器。 Telnet 是常用的远程控制Web服务器的方法。
- 但是，telnet 因为采用明文传送报文，安全性不好，很多 Linux 服务器都不开放 telnet 服务，而改用更安全的 ssh 方式了。但仍然有很多别的系统可能采用了 telnet 方式来提供远程登录，因此弄清楚 telnet 客户端的使用方式仍是很有必要的。
  
  > 本次我们安装和配置Telnet服务是为升级OpenSSH做准备，避免升级失败造成无法远程登录。

- 因为 Telnet 服务是通过 xinetd 服务启动的，所以我们需要先安装 xinetd 服务
  
  ```bash
  yum -y install  xinetd
  ```
- 开启 root 用户登录权限
- 编辑 `/etc/xinetd.d/telnet` 添加如下内容,如果没有此文件需要自己创建
  
  ```bash
  service telnet
  {
        disable         = no   #将disable设置为no，表示开启TELNET登录服务
        flags           = REUSE
        wait            = no
        socket_type     = stream
        user            = root
        server          = /usr/sbin/in.telnetd
        log_on_failure  += USERID
   }
  ```
- 编辑认证模块
  
  ```bash
  #%PAM-1.0
  #auth       required     pam_securetty.so    #注释掉第二行的安全验证配置，表示开启root用户登录权限
  auth       substack     password-auth
  auth       include      postlogin
  account    required     pam_nologin.so
  account    include      password-auth
  password   include      password-auth
  # pam_selinux.so close should be the first session rule
  session    required     pam_selinux.so close
  session    required     pam_loginuid.so
  # pam_selinux.so open should only be followed by sessions to be executed in the user context
  session    required     pam_selinux.so open
  session    required     pam_namespace.so
  session    optional     pam_keyinit.so force revoke
  session    include      password-auth
  session    include      postlogin
  ```
- 开启 TELNET 服务并设置开机启动
  
  ```bash
  systemctl start xinetd
  ```
- 将 TELNET 服务加入开机启动
  
  ```bash
  chkconfig telnet on
  ```
- TELNET 服务默认监听 23 端口
  
  ```bash
  [root@lv-achieve ~]# netstat -antpu | grep 23
  tcp6       0      0 :::23                   :::*                    LISTEN      45701/xinetd        
  udp        0      0 127.0.0.1:323           0.0.0.0:*                           681/chronyd         
  udp6       0      0 ::1:323                 :::*                                681/chronyd     
  ```
- 至此 TELNET 服务安装完毕，测试连接
  
  ```bash
  telnet IP
  ```



