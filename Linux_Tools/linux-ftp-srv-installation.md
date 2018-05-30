## CentOS7 安装 FTP 服务
- FTP 是 File Transfer Protocol (文件传输协议)。顾名思义，就是专门用来传输文件的协议。简单地说，支持 FTP 协议的服务器就是 FTP 服务器。
- CentOS 7 系统的 FTP 服务软件是 vsftpd ，FTP 服务的默认监听的端口是 TCP 的 21 端口，它其实也是一种 C/S 架构，分为服务端和客户端。

- FTP 默认的登录账户分为以下三种：
  
  ```bash
  匿名用户登录：默认开启，默认用户名 ftp 或者 anonymous，不安全
  
  本地账户登录：操作系统默认存在的本地用户，相对安全
  
  虚拟用户登录：需要创建特定的虚拟账号文件，安全
  ```
### 安装 FTP 服务
- CentOS 7 系统默认自带 ftp 相关软件 vsftpd，我们直接用 yum 安装即可：
  
  ```bash
  yum -y install vsftpd
  ```
- FTP 服务的配置文件路径 ： `/etc/vsftpd/vsftpd.conf`
