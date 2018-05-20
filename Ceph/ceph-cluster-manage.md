## Ceph集群管理
- 用 ceph-deploy 部署完成后会自动启动集群。
- Ceph 集群部署完成后，你可以尝试一下管理功能、 rados 对象存储命令，之后可以继续快速入门手册，了解 Ceph 块设备、 Ceph 文件系统和 Ceph 对象网关。

### 扩展Ceph集群
- 一个基本的集群启动并开始运行后，下一步就是扩展集群。

#### 添加 OSD
- 准备相关目录
  
  ``` bash
  ssh node1
  sudo mkdir /var/local/osd2
  exit
  ```
- **从 ceph-deploy 节点准备 OSD**
  
  ``` bash
  ceph-deploy osd prepare {ceph-node}:/path/to/directory
  ```
- 例如： 
  
  ``` bash
  ceph-deploy osd prepare node1:/var/local/osd2
  ```

- **激活OSD**
  
  ``` bash
  ceph-deploy osd activate {ceph-node}:/path/to/directory
  ```
- 例如： 
  
  ``` bash
  ceph-deploy osd activate node1:/var/local/osd2
  ```
- 一旦你新加了 OSD ， Ceph 集群就开始重均衡，把归置组迁移到新 OSD 。可以用下面的 ceph 命令观察此过程：
  ``` bash
  ceph -w
  ```

- 你应该能看到归置组状态从 active + clean 变为 active ，还有一些降级的对象；迁移完成后又会回到 active + clean 状态（ Control-C 退出）。

#### 添加元数据服务器

- 至少需要一个元数据服务器才能使用 CephFS ，执行下列命令创建元数据服务器：
  ``` bash
  ceph-deploy mds create {ceph-node}
  例如：
  ceph-deploy mds create node1
  ```
  
#### 添加 PGW 例程
- 要使用 Ceph 的 Ceph 对象网关组件，必须部署 RGW 例程。用下列方法创建新 RGW 例程：
  ``` bash
  ceph-deploy rgw create {gateway-node}
  例如：
  ceph-deploy rgw create node1
  ```

- RGW 例程默认会监听 7480 端口，可以更改该节点 ceph.conf 内与 RGW 相关的配置，如下：
  ``` xml
  [client]
  rgw frontends = civetweb port=80
  ```

#### 添加 MONITORS
- Ceph 存储集群需要至少一个 Monitor 才能运行。为达到高可用，典型的 Ceph 存储集群会运行多个 Monitors，这样在单个 Monitor 失败时不会影响 Ceph 存储集群的可用性。Ceph 使用 PASOX 算法，此算法要求有多半 monitors（即 1 、 2:3 、 3:4 、 3:5 、 4:6 等 ）形成法定人数。
- 这里，我增加两个MONITORS作为示范
  ``` bash
  ceph-deploy mon add {ceph-node}
  例如：
  ceph-deploy mon add node2 node3
  ```
- 新增 Monitor 后，Ceph 会自动开始同步并形成法定人数。你可以用下面的命令检查法定人数状态：
  ``` bash
  ceph quorum_status --format json-pretty
  ```
  
  
 

