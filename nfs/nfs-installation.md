## NFS 服务部署记录
 
### NFS 简单介绍
- NFS 是 Network File System 的缩写，即网络文件系统。一种使用于分散式文件系统的协定，由 Sun 公司开发，于 1984 年向外公布。功能是通过网络让不同的机器、不同的操作系统能够彼此分享个别的数据，让应用程序在客户端通过网络访问位于服务器磁盘中的数据，是在类 Unix 系统间实现磁盘文件共享的一种方法。
- NFS 的基本原则是“容许不同的客户端及服务端通过一组 RPC 分享相同的文件系统”，它是独立于操作系统，容许不同硬件及操作系统的系统共同进行文件的分享。
- NFS在文件传送或信息传送过程中依赖于RPC协议。RPC，远程过程调用 (Remote Procedure Call) 是能使客户端执行其他系统中程序的一种机制。NFS本身是没有提供信息传输的协议和功能的，但 NFS 却能让我们通过网络进行资料的分享，这是因为 NFS 使用了一些其它的传输协议。而这些传输协议用到这个 RPC 功能的。可以说NFS本身就是使用 RPC 的一个程序。或者说NFS也是一个 RPC SERVER。 所以只要用到NFS的地方都要启动 RPC 服务，不论是 NFS SERVER 或者 NFS CLIENT。 这样 SERVER 和 CLIENT 才能通过 RPC 来实现 PROGRAM PORT 的对应。可以这么理解 RPC 和 NFS 的关系：NFS是一个文件系统，而 RPC 是负责负责信息的传输。

### NFS 部署说明

#### 安装相关软件
- 安装 NFS 只需安装两个软件包即可：nfs-utils 、 rpcbind：
  
  ```bash
  yum -y install nfs-utils rpcbind
  ```

#### 安装完成后需要准备需要发布的目录
- 例如我们需要将本机(192.168.8.58)的 `/data/nfs_data` 目录分享给 192.168.8.57 的 `/data/m1` 目录

#### 在服务端配置
- 需要关闭防火墙和安全机制
  
  ```bash
  systemctl stop firewalld
  setenforce 0
  ```

- 编辑相关配置文件 `/etc/exports`，添加如下内容：
  
  ```bash
  /data/nfs_data   192.168.8.57(rw,sync,no_root_squash)
  ```
- 相关配置说明：
  
  ```bash
  rw :             #可读写的权限；
  ro :             #只读的权限；
  no_root_squash : #客户机用 root 访问 nfs 共享文件夹时，保持 root 权限，root_squash 是把 root 映射成 nobody，no_all_squash 不让所有用户保持在挂载目录中的权限。
  sync :           #资料同步写入存储器中。
  async :          #资料会先暂时存放在内存中，不会直接写入硬盘。
  ```

- 其中客户端常用的指定方式：
- 指定 ip 地址的主机: 192.168.1.19，如果是一个目录共享给多台客户机，那么就配置多行
- 指定子网中的所有主机: 192.168.0.0/24
- 指定域名的主机: a.liusuping.com
- 指定域中的所有主机: *.liusuping.com
- 所有主机:*
  


  
