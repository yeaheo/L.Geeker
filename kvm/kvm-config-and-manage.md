## kvm 虚拟机配置和管理
- KVM 虚拟机的日常管理主要是通过 `virsh` 命令进行的。
- 以下具体操作示例均在如下环境上进行操作示例，其他系统类似：
  
  ```bash
  $ sudo cat /proc/version
  Linux version 4.13.0-37-generic (buildd@lcy01-amd64-012) (gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.9)) #42~16.04.1-Ubuntu SMP Wed Mar 7 16:03:28 UTC 2018
  ```
- 查看 `virsh` 的具体功能可参考以下命令:

  ```bash
  $ sudo virsh help
  ```

### 查看虚拟机状态
- 查看虚拟机具体状态可参考如下：
  
  ```bash
  $ sudo virsh list --all
  Id    名称                         状态
  ----------------------------------------------------
  3     k8s-master                     running
  6     k8s-harbor                     running
  7     k8s-node1                      running
  8     k8s-node2                      running
  ```

### 虚拟机开关机
- 开启虚拟机可参考如下：
- 开启虚拟机有两种方式，一种是直接开机，另一种是通过配置文件开机。
- 直接开机：

  ```bash
  $ sudo virsh start  k8s-master   ## k8s-master即虚拟机名称
  ```

- 通过配置文件开机,KVM虚拟机的配置文件目录为`/etc/libvirt/qemu`:

  ```bash
  $ sudo virsh create /etc/libvirt/qemu/k8s-master.xml
  ```
- 关闭虚拟机可参考如下：
- 这里关闭虚拟机有两种方式，一种是直接关机，另一种是强制关闭电源。
- 直接关机:
  
  ```bash
  $ sudo virsh shutdown k8s-master
  ```
- 强制关闭电源：
  
  ```bash
  $ sudo virsh destroy k8s-master
  ```
- 配置虚拟机开机自启动
  
  ```bash
  $ sudo virsh autostart k8s-master
  ```
- 设置开机自动启动后，虚拟机配置文件路径`/etc/libvirt/qemu`中会生成一个`autostart`的目录，可以看到该目录中有KVM配置文件链接。
  
  ```bash
  yeaheo@yeaheo:/etc/libvirt/qemu/autostart$ pwd
  /etc/libvirt/qemu/autostart
  yeaheo@yeaheo:/etc/libvirt/qemu/autostart$ ls
  k8s-master.xml
  ```
### 虚拟机配置文件备份及导出
- 有时候我们需要备份虚拟机的配置文件或者导出虚拟机的配置文件，具体操作可以参考如下：
   
  ```bash
  virsh dumpxml k8s-master > /etc/libvirt/qemu/k8s-master-02.xml
  ```
### 删除或添加虚拟机
- 有时候我们需要删除废弃的虚拟机来释放资源
- 删除虚拟机：
  ```bash
  $ sudo virsh undefine k8s-master
  ```
  > 需要注意的是该命令只是删除了 k8s-master 的配置文件，并没有删除虚拟磁盘的文件，还需我们手动进行删除。

- 重新添加删除的虚拟机
- 之前我们导出过一份 k8s-master 这台虚拟机的配置，我们利用这个配置文件重新添加虚拟机
   
  ```bash
  root@yeaheo:/etc/libvirt/qemu# pwd
  /etc/libvirt/qemu
  root@yeaheo:/etc/libvirt/qemu# mv k8s-master-02.xml k8s-master.xml
  root@yeaheo:/etc/libvirt/qemu# virsh define ./k8s-master.xml
  ```

### 挂起或恢复虚拟机
- 挂起虚拟机
   
  ```bash
  root@yeaheo:~# virsh suspend k8s-master
  ```
- 恢复虚拟机
   
  ```bash
  root@yeaheo:~# virsh resume k8s-master
  ```

### 编辑虚拟机配置文件
- 编辑虚拟机配置文件
   
  ```bash
  root@yeaheo:~# virsh edit k8s-master
  ```
- 不建议用 vim 直接编辑虚拟机配置文件。
 
  
  
