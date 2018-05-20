## 安装 Linux 虚拟机
- 安装 Linux 虚拟机需要先准备磁盘文件和镜像文件
- 准备工作:
  
  ```bash
  [root@ns1 ~]# mkdir -pv /home/kvm/{kvm-img,kvm-iso}
  mkdir: created directory ‘/home/kvm’
  mkdir: created directory ‘/home/kvm/kvm-img’   #存放虚拟机磁盘文件
  mkdir: created directory ‘/home/kvm/kvm-iso’   #存放虚拟机镜像文件
  ```
- 创建磁盘文件，KVM支持两种类型的磁盘文件:raw,qcow2格式(空间动态增长)，在这里我们用qcow2格式做例子。
  
  ```bash
  qemu-img create -f qcow2 ctsig-test.img 100G
  ```
- 创建虚拟机
  
  ```bash
  virt-install --name ctsig-test --memory 4096 --vcpus=1 --disk path=/home/kvm/kvm-img/ctsig-svn.img,format=qcow2,size=150,bus=virtio --accelerate --cdrom /home/kvm/kvm-iso/CentOS-7-x86_64-DVD-1708.iso --vnc --vncport=5954 --vnclisten=0.0.0.0 --network bridge=br0,model=virtio --noautoconsole 
  ```
- 参数说明:
  ```bash
  --name        #指定虚拟机名称
  --ram         #分配内存大小。
  --vcpus       #分配CPU核心数，最大与实体机CPU核心数相同
  --disk        #指定虚拟机镜像，size指定分配大小单位为G。
  --network     #网络类型，此处用的是默认，一般用的应该是bridge桥接。
  --accelerate  #加速
  --cdrom       #指定安装镜像iso
  --vnc         #启用VNC远程管理，一般安装系统都要启用。
  --vncport     #指定VNC监控端口，默认端口为5900，端口不能重复。
  --vnclisten   #指定VNC绑定IP，默认绑定127.0.0.1，这里改为0.0.0.0。

  --os-type=linux,windows
  --os-variant=
```
- 为了可以连接创建的虚拟机，建议安装VNC。
