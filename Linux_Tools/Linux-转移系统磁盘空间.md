## 转移系统磁盘空间(支持xfs和ext4)
- 当我们在安装系统的时候，由于没有合理分配分区空间，在后续维护过程中，发现有些分区空间不够使用，而有的分区空间却有很多剩余空间。如果这些分区在装系统的时候使用了lvm（前提是这些分区要是lvm逻辑卷分区），那么就可以轻松进行扩容或缩容！不同文件系统类型所对应的创建、检查、调整命令不同，下面就针对xfs和ext2/3/4文件系统的lvm分区空间的扩容和缩容的操作做一记录
-
- 特别注意的：
  - `resize2fs` 针对的是ext2\ext3\ext4文件系统
  - `xfs_growfs` 针对的是xfs文件系统

### ext2/ext3/ext4文件系统的调整命令是resize2fs（增大和减小都支持）
- 具体命令如下:
  ``` bash
  lvextend -L 100G /dev/mapper/centos-home     //增大至100G
  lvextend -L +10G /dev/mapper/centos-home     //增加10G
  lvreduce -L 50G /dev/mapper/centos-home      //减小至50G
  lvreduce -L -2G /dev/mapper/centos-home      //减小2G
  resize2fs /dev/mapper/centos-home            //执行调整
  ```
### xfs文件系统的调整命令是xfs_growfs（只支持增大）
- 具体命令如下:
  ``` bash
  lvextend -L 120G /dev/mapper/centos-home    //增大至120G
  lvextend -L +20G /dev/mapper/centos-home    //增加20G
  xfs_growfs /dev/mapper/centos-home          //执行调整
  
  就是说：xfs文件系统只支持增大分区空间的情况，不支持减小的情况（切记！！！！！）
  如果要强制减小，只能在减小后将逻辑分区重新通过mkfs.xfs命令重新格式化才能挂载上，这样的话这个逻辑分区上原来的数据就丢失了
  ```
### 常见示例
#### 示例1
- 适用于当系统还有空闲空间的时候
- 查看分区空间大小，如下可知是xfs文件系统
  ``` bash
  [root@docker-master1 /]# df -hT
  文件系统            类型      容量  已用  可用 已用% 挂载点
  /dev/mapper/cl-root xfs        50G   17G   34G   34% /
  devtmpfs            devtmpfs  3.9G     0  3.9G    0% /dev
  tmpfs               tmpfs     3.9G   84K  3.9G    1% /dev/shm
  tmpfs               tmpfs     3.9G  393M  3.5G   11% /run
  tmpfs               tmpfs     3.9G     0  3.9G    0% /sys/fs/cgroup
  /dev/mapper/cl-home xfs        42G   37M   42G    1% /home
  /dev/vda1           xfs      1014M  228M  787M   23% /boot
  tmpfs               tmpfs     783M   16K  783M    1% /run/user/42
  tmpfs               tmpfs     783M     0  783M    0% /run/user/0
  ```
- 使用vgdisplay命令查看系统上的空闲空间
  ``` bash
  [root@docker-master1 /]# vgdisplay 
  --- Volume group ---
  VG Name               cl
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  5
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               3
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               99.00 GiB
  PE Size               4.00 MiB
  Total PE              25343
  Alloc PE / Size       17662 / 68.99 GiB
  Free  PE / Size       7681 / 30.00 GiB
  VG UUID               QUa47m-OKbr-u2RB-6d0V-LcQt-QNrx-RIG60R
  ```
- 将上面查到的空闲空间中的30G增减到/home分区上
- `lvextend -L +30G /dev/mapper/cl-home`
- `xfs_growfs /dev/mapper/cl-home`

- 再次检查磁盘空间
  ``` bash
  [root@docker-master1 /]# df -hT
  文件系统            类型      容量  已用  可用 已用% 挂载点
  /dev/mapper/cl-root xfs        50G   17G   34G   34% /
  devtmpfs            devtmpfs  3.9G     0  3.9G    0% /dev
  tmpfs               tmpfs     3.9G   84K  3.9G    1% /dev/shm
  tmpfs               tmpfs     3.9G  393M  3.5G   11% /run
  tmpfs               tmpfs     3.9G     0  3.9G    0% /sys/fs/cgroup
  /dev/mapper/cl-home xfs        72G   37M   72G    1% /home
  /dev/vda1           xfs      1014M  228M  787M   23% /boot
  tmpfs               tmpfs     783M   16K  783M    1% /run/user/42
  tmpfs               tmpfs     783M     0  783M    0% /run/user/0
  ```
  
###### 虽然xfs文件系统只支持增加，不支持减少。但并不是说在xfs系统文件下不能减小，只是减小后，需要重新格式化才能挂载上。这样原来的数据就丢失了！

#### 示例2
- 转移现有磁盘空间至新的磁盘(将/home下的30G放到/目录下)
- 这种情况只适用于系统刚安装好，逻辑分区内没有什么数据或数据不多且不重要可以删除或拷贝的情况下
- 查看分区空间大小，如下可知是xfs文件系统
  ``` bash
  [root@docker-master1 /]# df -hT
  文件系统            类型      容量  已用  可用 已用% 挂载点
  /dev/mapper/cl-root xfs        50G   17G   34G   34% /
  devtmpfs            devtmpfs  3.9G     0  3.9G    0% /dev
  tmpfs               tmpfs     3.9G   84K  3.9G    1% /dev/shm
  tmpfs               tmpfs     3.9G  393M  3.5G   11% /run
  tmpfs               tmpfs     3.9G     0  3.9G    0% /sys/fs/cgroup
  /dev/mapper/cl-home xfs        42G   37M   42G    1% /home
  /dev/vda1           xfs      1014M  228M  787M   23% /boot
  tmpfs               tmpfs     783M   16K  783M    1% /run/user/42
  tmpfs               tmpfs     783M     0  783M    0% /run/user/0
  ```
- 卸载/home目录
- `umount /home/`
- `lvreduce -L -30G /dev/mapper/cl-home`
- 重新格式化/home目录
- `mkfs.xfs /dev/mapper/cl-home -f`
- 重新挂载/home
- `mount /dev/mapper/cl-home /home/`
- 检查系统空闲空间
  ``` bash
  [root@docker-master1 /]# vgdisplay 
  --- Volume group ---
  VG Name               cl
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  5
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               3
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               99.00 GiB
  PE Size               4.00 MiB
  Total PE              25343
  Alloc PE / Size       17662 / 68.99 GiB
  Free  PE / Size       7681 / 30.00 GiB
  VG UUID               QUa47m-OKbr-u2RB-6d0V-LcQt-QNrx-RIG60R
  ```
- 增加/目录的磁盘空间
- `lvextend -L +30G /dev/mapper/cl-root`
- 执行调整
- `xfs_growfs /dev/mapper/cl-root`
- 再次检查磁盘空间利用率，发现/目录增加了30G，而/home目录减下了30G
  ``` bash
  [root@docker-master1 /]# df -hT
  文件系统            类型      容量  已用  可用 已用% 挂载点
  /dev/mapper/cl-root xfs        80G   17G   64G   22% /
  devtmpfs            devtmpfs  3.9G     0  3.9G    0% /dev
  tmpfs               tmpfs     3.9G   84K  3.9G    1% /dev/shm
  tmpfs               tmpfs     3.9G  401M  3.5G   11% /run
  tmpfs               tmpfs     3.9G     0  3.9G    0% /sys/fs/cgroup
  /dev/vda1           xfs      1014M  228M  787M   23% /boot
  tmpfs               tmpfs     783M   16K  783M    1% /run/user/42
  tmpfs               tmpfs     783M     0  783M    0% /run/user/0
  /dev/mapper/cl-home xfs        12G   33M   12G    1% /home
  ```
### 出现的问题及解决办法
- 若是减小分区空间，减小前必须要先卸载这个分区。
- 如果卸载有问题，解决如下：
  ``` bash
  [root@localhost ~]# umount /home/
  umount: /home: device is busy.
  (In some cases useful info about processes that use
  the device is found by lsof(8) or fuser(1))
  ```
- 提示无法卸载，则是有进程占用/home，使用如下命令来终止占用进程：
- 解决办法如下：
  ``` bash
  [root@localhost ~]# fuser -m -k /home
  /home: 1409 1519ce 1531e 1532e 1533e 1534e 1535e 1536e 1537e 1538e 1539e 1541e 1543e 1544e 1545e 1546e 1547e 1548e 1549e 1550e 1601m
  ```
- 再次卸载home分区就成功了。
- `umount /home/`
  
