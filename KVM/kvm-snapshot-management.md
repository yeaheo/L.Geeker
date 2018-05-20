## kvm 虚拟机快照备份
- kvm 虚拟机默认使用的是 `raw` 格式的磁盘，这种磁盘速度最快，性能最好，但是这种格式的磁盘是不支持镜像功能的，也不支持 zlib 磁盘压缩和 AES 加密。
- 所以我们需要转换磁盘格式，将 raw 格式的磁盘转换成 qcow2 格式即可。

- 查看磁盘信息
  
  ```bash
  root@yeaheo:/home/kvm/kvm-img# qemu-img info yeah-k8s-master.img 
  image: yeah-k8s-master.img
  file format: qcow2    ## 磁盘格式
  virtual size: 50G (53687091200 bytes)
  disk size: 2.9G
  cluster_size: 65536
  Snapshot list:
  ID        TAG                 VM SIZE                DATE       VM CLOCK
  1         1521270428             971M 2018-03-17 15:07:08   41:34:50.052
  Format specific information:
      compat: 1.1
      lazy refcounts: false
      refcount bits: 16
      corrupt: false
  ```
- 可以看到我磁盘的格式本身就是qcow2格式，如果你的磁盘是raw格式，就需要关闭虚拟机并转换磁盘格式了，具体如下：
  
  ```bash
  # qemu-img convert -f raw -O qcow2 test.img test.qcow2 
  
  参数说明：
  -f  源镜像的格式   
  -O 目标镜像的格式
  ```
- 修改磁盘文件后，还需要修改虚拟机配置文件，将磁盘的信息修改成新的磁盘（test.qcow2）参数。

### 创建虚拟机快照
- 对 k8s-master 虚拟机创建快照
  
  ```bash
  # virsh snapshot-create k8s-master
  ```
- 查看 k8s-master 虚拟机快照文件
  
  ```bash
  root@yeaheo:~# virsh snapshot-list k8s-master
  名称               生成时间              状态
  ------------------------------------------------------------
  1521270428           2018-03-17 15:07:08 +0800 running
  1521341785           2018-03-18 10:56:25 +0800 running
  ```
- 查看 k8s-master 虚拟机当前快照版本
  
  ```bash
  # virsh snapshot-current k8s-master
  ....
  <domainsnapshot>
  <name>1521341785</name>
  <state>running</state>
  <parent>
    <name>1521270428</name>
  ```
- 可以看到当前是最新版本的快照。
- 快照配置文件在 `/var/lib/libvirt/qemu/snapshot/虚拟机名称/` 下。
  
  ```bash
  root@yeaheo:/var/lib/libvirt/qemu/snapshot/k8s-master# ls
  1521270428.xml  1521341785.xml
  ```
### 虚拟机快照管理
- 首先需要确认虚拟机已经关机
- 恢复虚拟机快照
  
  ```bash
  root@yeaheo:~# virsh snapshot-list k8s-master
  名称               生成时间              状态
  ------------------------------------------------------------
  1521270428           2018-03-17 15:07:08 +0800 running
  1521341785           2018-03-18 10:56:25 +0800 running
  
  root@yeaheo:~# virsh snapshot-revert k8s-master 1521341785
  ```
- 删除虚拟机快照
  
  ```bash
  root@yeaheo:~# virsh snapshot-list k8s-master
  名称               生成时间              状态
  ------------------------------------------------------------
  1521270428           2018-03-17 15:07:08 +0800 running
  1521341785           2018-03-18 10:56:25 +0800 running
  
  root@yeaheo:~# virsh snapshot-delete k8s-master 1521270428
  已删除域快照 1521270428
  ```
  




  
