### NFS服务部署记录

#### NFS简单介绍
- NFS 是Network File System的缩写，即网络文件系统。一种使用于分散式文件系统的协定，由Sun公司开发，于1984年向外公布。功能是通过网络让不同的机器、不同的操作系统能够彼此分享个别的数据，让应用程序在客户端通过网络访问位于服务器磁盘中的数据，是在类Unix系统间实现磁盘文件共享的一种方法。
- NFS 的基本原则是“容许不同的客户端及服务端通过一组RPC分享相同的文件系统”，它是独立于操作系统，容许不同硬件及操作系统的系统共同进行文件的分享。
- NFS在文件传送或信息传送过程中依赖于RPC协议。RPC，远程过程调用 (Remote Procedure Call) 是能使客户端执行其他系统中程序的一种机制。NFS本身是没有提供信息传输的协议和功能的，但NFS却能让我们通过网络进行资料的分享，这是因为NFS使用了一些其它的传输协议。而这些传输协议用到这个RPC功能的。可以说NFS本身就是使用RPC的一个程序。或者说NFS也是一个RPC SERVER。所以只要用到NFS的地方都要启动RPC服务，不论是NFS SERVER或者NFS CLIENT。这样SERVER和CLIENT才能通过RPC来实现PROGRAM PORT的对应。可以这么理解RPC和NFS的关系：NFS是一个文件系统，而RPC是负责负责信息的传输。

#### NFS部署说明

##### 安装NFS只需安装两个软件包即可：nfs-utils 、 rpcbind
- `yum -y install nfs-utils rpcbind`

##### 安装完成后需要准备需要发布的目录
  - 例如我们需要将本机(192.168.8.58)的`/data/nfs_data`目录分享给192.168.8.57的`/data/m1`目录

##### 在服务端配置
- 需要关闭防火墙和安全机制
  - `systemctl stop firewalld`
  - `setenforce 0`

- 编辑相关配置文件`/etc/exports`，添加如下内容：
  - ``` xml
    /data/nfs_data   192.168.8.57(rw,sync,no_root_squash)
    ```
- 相关配置说明：
  - `rw`: 可读写的权限；
  - `ro`: 只读的权限；
  - `no_root_squash`: 客户机用root访问nfs共享文件夹时，保持root权限，root_squash 是把root映射成nobody，no_all_squash 不让所有用户保持在挂载目录中的权限。
  - `sync`: 资料同步写入存储器中。
  - `async`: 资料会先暂时存放在内存中，不会直接写入硬盘。
- 其中客户端常用的指定方式：
  - 指定ip地址的主机:192.168.1.19，如果是一个目录共享给多台客户机，那么就配置多行
  - 指定子网中的所有主机:192.168.0.0/24
  - 指定域名的主机:a.liusuping.com
  - 指定域中的所有主机:*.liusuping.com
  - 所有主机:*
  


  
