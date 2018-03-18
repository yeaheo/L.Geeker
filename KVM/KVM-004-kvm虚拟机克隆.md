## kvm虚拟机克隆配置
- 在大多数情况下我们安装虚拟机的时候都会感到特别慢，而且新安装的虚拟机一些必须的软件包还需要单独下载安装，为了简化我们的操作步骤，有时候我们需要配置一个虚拟机模板，然后
直接克隆此虚拟机模板即可。
- 本文档主要介绍KVM虚拟机的克隆部分
- KVM虚拟机克隆分两种情况，具体如下：
- 1、**本机虚拟机克隆**
- 2、**异机虚拟机克隆**
- 下面分别对两种情况进行说明。

### 本机虚拟机克隆
- 环境为我的实验环境，具体问题还需按照实际情况进行操作。
- 首先，我们需要克隆的虚拟机如下：
  ``` bash
  root@yeaheo:/# virsh list --all
  Id    名称                         状态
  ----------------------------------------------------
  3     k8s-master                     running   ## 需要克隆的虚拟机
  6     k8s-harbor                     running
  7     k8s-node1                      running
  8     k8s-node2                      running
  ```
- 需要克隆的虚拟机配置文件如下：
  ``` xml
  root@yeaheo:/# cat /etc/libvirt/qemu/k8s-master.xml 
  <!--
  WARNING: THIS IS AN AUTO-GENERATED FILE. CHANGES TO IT ARE LIKELY TO BE
  OVERWRITTEN AND LOST. Changes to this xml configuration should be made using:
  virsh edit k8s-master
  or other application using the libvirt API.
  -->
  
  <domain type='kvm'>
    <name>k8s-master</name>
    <uuid>763dd3b3-df8d-40a4-bdc8-63f0aa6e3b54</uuid>
    <memory unit='KiB'>1048576</memory>
    <currentMemory unit='KiB'>1048576</currentMemory>
    <vcpu placement='static'>2</vcpu>
    <os>
      <type arch='x86_64' machine='pc-i440fx-xenial'>hvm</type>
      <boot dev='hd'/>
    </os>
    <features>
      <acpi/>
      <apic/>
    </features>
    <cpu mode='custom' match='exact'>
      <model fallback='allow'>Broadwell</model>
    </cpu>
    <clock offset='utc'>
      <timer name='rtc' tickpolicy='catchup'/>
      <timer name='pit' tickpolicy='delay'/>
      <timer name='hpet' present='no'/>
    </clock>
    <on_poweroff>destroy</on_poweroff>
    <on_reboot>restart</on_reboot>
    <on_crash>restart</on_crash>
    <pm>
      <suspend-to-mem enabled='no'/>
      <suspend-to-disk enabled='no'/>
    </pm>
    <devices>
      <emulator>/usr/bin/kvm-spice</emulator>
      <disk type='file' device='disk'>
        <driver name='qemu' type='qcow2'/>
        <source file='/home/kvm/kvm-img/yeah-k8s-master.img'/>
        <target dev='vda' bus='virtio'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x06' function='0x0'/>
      </disk>
      <disk type='file' device='cdrom'>
        <driver name='qemu' type='raw'/>
        <target dev='hda' bus='ide'/>
        <readonly/>
        <address type='drive' controller='0' bus='0' target='0' unit='0'/>
      </disk>
      <controller type='usb' index='0' model='ich9-ehci1'>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x7'/>
      </controller>
      <controller type='usb' index='0' model='ich9-uhci1'>
        <master startport='0'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0' multifunction='on'/>
      </controller>
      <controller type='usb' index='0' model='ich9-uhci2'>
        <master startport='2'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x1'/>
      </controller>
      <controller type='usb' index='0' model='ich9-uhci3'>
        <master startport='4'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x2'/>
      </controller>
      <controller type='pci' index='0' model='pci-root'/>
      <controller type='ide' index='0'>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x1'/>
      </controller>
      <controller type='virtio-serial' index='0'>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x0'/>
      </controller>
      <interface type='bridge'>
        <mac address='52:54:00:47:2b:24'/>
        <source bridge='br0'/>
        <model type='virtio'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
      </interface>
      <serial type='pty'>
        <target port='0'/>
      </serial>
      <console type='pty'>
        <target type='serial' port='0'/>
      </console>
      <channel type='unix'>
        <source mode='bind'/>
        <target type='virtio' name='org.qemu.guest_agent.0'/>
        <address type='virtio-serial' controller='0' bus='0' port='1'/>
      </channel>
      <input type='tablet' bus='usb'/>
      <input type='mouse' bus='ps2'/>
      <input type='keyboard' bus='ps2'/>
      <graphics type='vnc' port='5950' autoport='no' listen='0.0.0.0'>
        <listen type='address' address='0.0.0.0'/>
      </graphics>
      <video>
        <model type='cirrus' vram='16384' heads='1'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0'/>
      </video>
      <memballoon model='virtio'>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>
      </memballoon>
    </devices>
  </domain>
  ```
- 虚拟机磁盘文件如下：
  ``` bash
  /home/kvm/kvm-img/yeah-k8s-master.img
  ```
- 克隆上述虚拟机(用virt-clone命令)
- **virt-clone**命令详细参数参见 `virt-clone --help`
  
  ``` bash
  # virt-clone -o k8s-master -n k8s-master-bak -f /home/kvm/kvm-img/yeah-k8s-master-bak.img
  
  参数说明：
  -o ORIGINAL_GUEST, --original ORIGINAL_GUEST
                        原始客户机名称；必须为关闭或者暂停状
                        态。
  -n NEW_NAME, --name NEW_NAME
                        新客户机的名称
  -f NEW_DISKFILE, --file NEW_DISKFILE
                        为新客户机使用新的磁盘镜像文件
  
  需要注意的是：必须暂停或者关闭有要克隆设备的域，否则会提示报错。
  ```
- 克隆完虚拟机后还需要对其做些配置，例如主机名、IP地址等，以免和源主机相同。

### 异机虚拟机克隆
- 环境如下：
  ``` bash
  root@yeaheo:~# virsh list --all
  Id    名称                         状态
  ----------------------------------------------------
  3     k8s-master                     running     ## 需要克隆的虚拟机
  6     k8s-harbor                     running
  7     k8s-node1                      running
  8     k8s-node2                      running
  ```
- 因为是异机克隆，本次在本机上模拟异机，原理相同。
- 准备新虚拟机配置文件
  ``` bash
  # virsh dumpxml k8s-master > /opt/k8s-master.xml
  ```
- 复制需要克隆的虚拟机磁盘文件
  ``` bash
  # cp yeah-k8s-master.img /opt/yeah-k8s-master-clone.img
  ```
- 修改新虚拟机配置文件以下内容为新虚拟机的实际参数
  ``` xml
  ......
  <name>k8s-master-clone</name>
  <uuid>763dd3b3-df8d-40a4-bdc8-63f0aa6e3b54</uuid>
  ......
  <source file='/opt/yeah-k8s-master-clone.img'/>
  ......
  <graphics type='vnc' port='5950' autoport='no' listen='0.0.0.0'>
  ......
  ```
- 定义新虚拟机配置文件
  ``` bash
  # virsh define /opt/k8s-master.xml
  ```
- 开启虚拟机
  ``` bash
  # virsh start k8s-master-clone
  ```
- 克隆完虚拟机后还需要对其做些配置，例如主机名、IP地址等，以免和源主机相同。

  
