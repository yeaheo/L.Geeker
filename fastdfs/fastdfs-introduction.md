### FastDFS 简单介绍
- FastDFS 是一个开源的轻量级分布式文件系统，它对文件进行管理，功能包括：文件存储、文件同步、文件访问（文件上传、文件下载）等，解决了大容量存储和负载均衡的问题。特别适合以文件为载体的在线服务，如相册网站、视频网站等等。
- FastDFS 为互联网量身定制，充分考虑了冗余备份、负载均衡、线性扩容等机制，并注重高可用、高性能等指标，使用FastDFS很容易搭建一套高性能的文件服务器集群提供文件上传、下载等服务。

- FastDFS is an open source high performance distributed file system (DFS). It's major functions include: file storing, file syncing and file accessing, and design for high capacity and load balance.
- 翻译：FastDFS 是一个开源的高性能分布式文件系统（DFS）。 它的主要功能包括：文件存储，文件同步和文件访问，以及高容量和负载平衡。
- 这是余庆老师在他的 Github 上介绍关于 FastDFS 这个开源项目的描述。说的很明白了，这是一个高性能的轻量级开源分布式文件系统，解决了我们日常项目中众所周知的文件存储性能问题，几乎适合市面上所有项目使用，据说好多家你知道的大公司也在使用，甚至你使用的各大网盘公司也在使用（尽管最近多家网盘公司关闭了），反正就是特别好用。感谢余庆老师对开源世界的无私奉献，这是余老师的 GitHub 地址： <https://github.com/happyfish100/fastdfs>

### FastDFS 组成
- FastDFS 系统有三个角色：跟踪服务器(Tracker Server)、存储服务器(Storage Server)和客户端(Client)。
- `Tracker Server`: 跟踪服务器，主要做调度工作，起到均衡的作用；负责管理所有的 storage server和 group，每个 storage 在启动后会连接 Tracker，告知自己所属 group 等信息，并保持周期性心跳。
- `Storage Server`：存储服务器，主要提供容量和备份服务；以 group 为单位，每个 group 内可以有多台 storage server，数据互为备份。
- `Client`:客户端，上传下载数据的服务器，也就是我们自己的项目所部署在的服务器。
- FastDFS 架构图如下图所示：
- ![FastDFS 架构图](../images/FastDFS.png)
- 上述架构优点：1.高可靠性：无单点故障 2.高吞吐性：只要 Group 足够多，数据流量将足够分散。

### FastDFS 怎么上传下载以及同步文件这么操作呢？
- 我在这就不详细说全部流程了，大概上传流程就是客户端发送上传请求到 Tracker Server 服务器，接着 Tracker Server 服务器分配 group 和 Storage Server，当然这是有一定规则的，选择好 Storage Server 后再根据一定规则选择存储在这个服务器会生成一个 file_id，这个 file_id 包含字段包括：storage server ip、文件创建时间、文件大小、文件 CRC32 校验码和随机数；每个存储目录下有两个 256 * 256 个子目录，后边你会知道一个 Storage Server 存储目录下有好多个文件夹的，storage 会按文件 file_id 进行两次 hash ，路由到其中一个子目录，然后将文件存储到该子目录下，最后生成文件路径：group 名称、虚拟磁盘路径、数据两级目录、file_id和文件后缀就是一个完整的文件地址。
- 可能我理解的也不是很彻底，下载、同步操作我不写了，这里有一篇文章 [分布式文件系统 FastDFS 设计原理](http://blog.chinaunix.net/uid-20196318-id-4058561.html) 讲解的很详细，我就不班门弄斧了，大家可以点击去看看
  
