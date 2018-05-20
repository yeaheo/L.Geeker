### Ceph简单介绍
- 不管你是想为云平台提供 `Ceph` 对象存储和/或 `Ceph` 块设备，还是想部署一个 `Ceph` 文件系统或者把 `Ceph` 作为他用，所有 `Ceph` 存储集群的部署都始于部署一个个 `Ceph` 节点、网络和 `Ceph` 存储集群。  `Ceph` 存储集群至少需要一个 `Ceph Monitor` 和两个 `OSD` 守护进程。而运行 `Ceph`文件系统客户端时，则必须要有元数据服务器（ Metadata Server ）。
- 具体各个部分介绍如下：
  - `Ceph OSDs`: Ceph OSD 守护进程（ Ceph OSD ）的功能是存储数据，处理数据的复制、恢复、回填、再均衡，并通过检查其他OSD 守护进程的心跳来向 Ceph Monitors 提供一些监控信息。当 Ceph 存储集群设定为有2个副本时，至少需要2个 OSD 守护进程，集群才能达到 active+clean 状态（ Ceph 默认有3个副本，但你可以调整副本数）。
  - `Monitors`: Ceph Monitor 维护着展示集群状态的各种图表，包括监视器图、 OSD 图、归置组（ PG ）图、和 CRUSH 图。 Ceph 保存着发生在Monitors 、 OSD 和 PG 上的每一次状态变更的历史信息（称为 epoch ）。
  - `MDSs`: Ceph 元数据服务器（ MDS ）为 Ceph 文件系统存储元数据（也就是说，Ceph 块设备和 Ceph 对象存储不使用MDS ）。元数据服务器使得 POSIX 文件系统的用户们，可以在不对 Ceph 存储集群造成负担的前提下，执行诸如 ls、find 等基本命令。
- `Ceph` 把客户端数据保存为存储池内的对象。通过使用 `CRUSH` 算法， `Ceph` 可以计算出哪个归置组（PG）应该持有指定的对象 (Object)，然后进一步计算出哪个`OSD` 守护进程持有该归置组。 `CRUSH` 算法使得 `Ceph` 存储集群能够动态地伸缩、再均衡和修复。
