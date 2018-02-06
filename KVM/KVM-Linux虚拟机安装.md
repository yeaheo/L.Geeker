## KVM虚拟机管理
- 安装Linux虚拟机需要先准备磁盘文件和镜像文件
- 准备工作:
``` bash
[root@ns1 ~]# mkdir -pv /home/kvm/{kvm-img,kvm-iso}
mkdir: created directory ‘/home/kvm’
mkdir: created directory ‘/home/kvm/kvm-img’   #存放虚拟机磁盘文件
mkdir: created directory ‘/home/kvm/kvm-iso’   #存放虚拟机镜像文件
```
- 创建磁盘文件，KVM支持两种类型的磁盘文件:raw,qcow2格式(空间动态增长)，在这里我们用qcow2格式做例子。
``` bash
qemu-img create -f qcow2 ctsig-test.img 100G
```
