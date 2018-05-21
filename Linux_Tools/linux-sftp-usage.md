## sftp 的使用方式
- sftp 是Secure File Transfer Protocol 的缩写，安全文件传送协议。可以为传输文件提供一种安全的网络的加密方法。

### sftp 的用法：
- 示例： 如远程主机的 IP 是 192.168.1.1 或者域名是 <www.xxx.com>,用户名是 root，在命令行模式下： `sftp root@192.168.1.1` 或者 `sftp root@www.xxx.com` 回车进入命令行
  
  ```bash
  sftp>
  ```
- sftp 的使用方法常用的有两种，分别如下：
- 第一种：从远程主机下载文件
  ```bash
  sftp> get /opt/CentOS-Base.repo.bak /tmp/
  # 解释一下：
  # /opt/CentOS-Base.repo.bak 为远程主机目录及文件，/tmp/是本地主机及文件。
  ```
- 第二种：把本地文件传输到远程主机
  ```bash
  sftp> put /opt/tomcat-log.sh /opt/
  # 解释一下：
  # /opt/tomcat-log.sh 为本地主机的目录及文件，/opt是远程主机的文件。
  ```
- 补充：
`pwd`:  显示远程主机的当前目录
`lpwd`: 显示本地主机的当前目录
`cd`  : 切换远程主机所在目录
`lcd` : 切换本地主机所在目录
- 其他的如 `ls rm rmdir mkdir` 这些命令都可以使用，调用本机的加 `l`即可。
- 如果远程主机的 SSH 服务不是默认的缺省端口 22，则需要使用 `-o选项指定端口`，如：
  ```bash
  sftp -o port=60066 user@serverip
  ```
