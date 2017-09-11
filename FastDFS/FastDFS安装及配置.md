## FastDFS安装及配置

### FastDFS介绍
- FastDFS 详细介绍：<http://www.oschina.net/p/fastdfs>
- 官网下载 1：<https://github.com/happyfish100/fastdfs/releases>
- 官网下载 2：<https://sourceforge.net/projects/fastdfs/files/>
- 官网下载 3：<http://code.google.com/p/fastdfs/downloads/list>

### FastDFS安装配置

#### 安装libfastcommon
- download libfastcommon source package from github and install it
- the github address: <https://github.com/happyfish100/libfastcommon.git>
- `yum -y install git wget`
- `git clone https://github.com/happyfish100/libfastcommon.git`
- `mv libfastcommon /usr/local/`
- `cd /usr/local/libfastcommon`
- `./make.sh && ./make.sh install`

#### 安装FastDFS
- download FastDFS source package and unpack it
- `git clone https://github.com/happyfish100/fastdfs`
- `mv fastdfs /usr/local/`
- `cd /usr/local/fastdfs`
- `./make.sh && ./make.sh install`

#### 配置Tracker服务
- 安装完成后会在/etc/fdfs目录下生成配置文件，我们需要修改一下配置文件
- `cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf`
- 具体参照以下命令：
  - 这里我们把fdfs的数据目录设置为/data/fastdfs
  - `sed -i '22s/\/home\/yuqing\/fastdfs/\/data\/fastdfs/g' /etc/fdfs/tracker.conf`
  - 修改HTTP端口
  - `sed -i '260s/8080/80/g' /etc/fdfs/tracker.conf`
- 当然前提是你要有或先创建了/data/fastdfs目录。port=22122这个端口参数不建议修改，除非你已经占用它了。
修改完成保存并退出 vim ，这时候我们可以使用/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf start来启动 Tracker服务，但是这个命令不够优雅，怎么做呢？使用ln -s 建立软链接：
  - `ln -s /usr/bin/fdfs_trackerd /usr/local/bin`
  - `ln -s /usr/bin/stop.sh /usr/local/bin`
  - `ln -s /usr/bin/restart.sh /usr/local/bin`
- 这时候我们就可以使用`service fdfs_trackerd start`来优雅地启动 Tracker服务了
- 启动Tracker服务后查看一下监听端口：
  - `netstat -unltp|grep fdfs`

#### 配置Storage服务
- 现在开始配置 Storage 服务，由于我这是单机器测试，你把 Storage 服务放在多台服务器也是可以的，它有 Group(组)的概念，同一组内服务器互备同步，这里不再演示。直接开始配置，依然是进入/etc/fdfs的目录操作，首先进入它。会看到三个.sample后缀的文件，我们需要把其中的storage.conf.sample文件改为storage.conf配置文件并修改它。
- `cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf`
- `vim /etc/fdfs/storage.conf`
  
  ``` xml
  # the base path to store data and log files
  base_path=/data/fastdfs/storage
  
  # store_path#, based 0, if store_path0 not exists, it's value is base_path
  # the paths must be exist
  store_path0=/data/fastdfs/storage
  #store_path1=/home/yuqing/fastdfs2
  
  # tracker_server can ocur more than once, and tracker_server format is
  #  "host:port", host can be hostname or ip address
  tracker_server=192.168.8.129:22122
  ```
  - 注意：192.168.8.129为tracker服务器IP地址
- 修改完成保存并退出 vim ，这时候我们依然想优雅地启动 Storage服务，带目录的命令不够优雅，这里还是使用ln -s 建立软链接：
  - `ln -s /usr/bin/fdfs_storaged /usr/local/bin`
  - 启动服务
  - `service fdfs_storaged start`
  - 查看监听端口
  - `netstat -unltp|grep fdfs`
  
