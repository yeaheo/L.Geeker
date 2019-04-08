## CentOS 7 安装 FTP 服务
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

### 启动 FTP 服务
- 安装完成后，启动服务并设置成开机自启：

  ```bash
  systemctl start vsftpd.service
  systemctl enable vsftpd.service
  ```
### 配置 FTP 服务
- 默认情况下， ftp 服务并不满足我们的需求而且不安全，我们需要做些优化。

#### 匿名用户登录
- FTP 默认开启匿名登录，因为不安全，将其关闭：
  
  ```bash
  ...
  anonymous_enable=NO
  ...
  ```
#### 本地用户登录
- 本地用户登录需要该用户在系统内真实存在。
- 新建用户：

  ```bash
  useradd -g ftp -s /sbin/nologin ctftp
  echo "xx" | passwd --stdin ctftp
  ```

- 修改原配置文件：

  ```bash
  anonymous_enable=NO         # 禁用匿名登录
  ascii_upload_enable=YES
  ascii_download_enable=YES
  chroot_local_user=YES       # 启用限定用户在其主目录下
  ```
  
- 新加入如下优化内容：

  ```bash
  userlist_enable=YES
  userlist_deny=NO
  userlist_file=/etc/vsftpd/allow_users # 该文件需要手动创建，每行一个允许登录的用户名
  allow_writeable_chroot=YES
  
  accept_timeout=60
  connect_timeout=60
  max_clients=300
  max_per_ip=3
  local_max_rate=50000
  anon_max_rate=30000
  pasv_min_port=50000
  pasv_min_port=60000
  ```
- 重启 FTP 服务，即可完成 FTP 本地用户登录的相关配置，因为之前测试过，没有问题，可以正常使用，这里不再赘述。

  > 推荐一款 FTP 专用客户端软件：FileZilla 。下载地址：<https://download.filezilla-project.org/client/FileZilla_3.33.0_win64-setup_bundled.exe>
  
#### 虚拟用户登录
- 时间问题，后续更新...
