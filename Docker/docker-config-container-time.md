## Docker-同步容器与宿主机时间

- 在Docker容器创建好之后，可能会发现容器时间跟宿主机时间不一致，这就需要同步它们的时间，让容器时间跟宿主机时间保持一致。

- 宿主机时间：
  
  ```bash
  [root@ceph-node1 ~]# date
  2017年 07月 30日 星期日 13:46:52 CST
  ```
- 容器时间：
  
  ```bash
  [root@ceph-node1 ~]# docker run -i -t centos:latest /bin/bash
  [root@0ce1de90e209 /]# date
  Sun Jul 30 05:47:14 UTC 2017
  ```
- 发现两者之间的时间相差了八个小时！
- 宿主机采用了 CST 时区，CST 应该是指（China Shanghai Time，东八区时间）
- 容器采用了 UTC 时区，UTC 应该是指（Coordinated Universal Time，标准时间）

### 统一两者的时区有下面几种方法

#### 方法1：共享主机的 localtime
- 创建容器的时候指定启动参数，挂载 localtime 文件到容器内，保证两者所采用的时区是一致的。
- 示例如下：
  
  ```bash
  [root@ceph-node1 ~]# docker run -i -t --name my-httpd -v /etc/localtime:/etc/localtime:ro centos:httpd /bin/bash
  [root@be91e9bd5d95 /]# date
  Sun Jul 30 14:01:53 CST 2017
  ```
#### 方法2：复制主机的 localtime
- 示例如下：
- 修改前
  
  ```bash
  [root@ceph-node1 ~]# docker run -i -t centos:latest /bin/bash
  [root@0ce1de90e209 /]# date
  Sun Jul 30 05:47:14 UTC 2017
  ```
- 修改后
  
  ```bash
  [root@ceph-node1 ~]# docker cp /etc/localtime 9ec4c03133dd:/etc
  [root@ceph-node1 ~]# docker start 9ec4c03133dd
  9ec4c03133dd
  [root@ceph-node1 ~]# docker attach 9ec4c03133dd
  [root@9ec4c03133dd /]# date
  Sun Jul 30 14:05:25 CST 2017
  ```

#### 方法3：创建dockerfile文件的时候，自定义该镜像的时间格式及时区。在dockerfile文件里添加下面内容：
- 示例dockerfile文件如下：
  
  ```bash
  ......
  #设置时区
  RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone
  ......
  ```
  
  ```bash
  [root@ceph-node1 centos]# docker build -t centos:zone .
  [root@ceph-node1 centos]# docker run -i -t centos:zone /bin/bash
  [root@5d143e9813f7 /]# date
  Sun Jul 30 13:49:42 CST 2017
  ```
  > 使用 dokcerfile 生成的镜像的容器改变了容器的时区，这样不仅保证了容器时间与宿主机时间一致，并且如果用 tomcat 镜像作为基础镜像的话，JVM 的时区也是和宿主机保持一致，前两种方法只是保证了素质宿主机时间与容器时间一致，JVM 的时区并没有该 Bain， tomcat 打印的日志不会改变。




