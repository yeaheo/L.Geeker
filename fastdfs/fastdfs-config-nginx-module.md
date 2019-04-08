## FastDFS 配置 Nginx 模块
- 安装了 FastDFS 后，并配置启动了 Tracker 和 Storage 服务，已经可以上传文件了，但是我没有上传测试，因为上传成功我看不了，所以，需要配合 Nginx 来进行文件的上传下载，这一篇就安装 Nginx 以及结合 fastdfs-nginx-module 模块使用。
- Nginx的安装过程具体参见 [Nginx安装](../Nginx/nginx-installation-and-config.md)

### 下载 fastdfs-nginx-module 源代码
- 从 GitHub 上下载 fastdfs-nginx-module 源代码：

  ```bash
  git clone https://github.com/happyfish100/fastdfs-nginx-module
  ```

### 配置 nginx 安装，加入fastdfs-nginx-module模块
- 在安装 nginx 的时候添加如下配置然后重新编译 nginx
  
  ```bash
  ./configure --add-module=/path/to/fastdfs-nginx-module-master/src
  make && make install
  ```
- 这时候，我们可以看一下 Nginx 下安装成功的版本及模块，命令：
  
  ```bash
  nginx -V
  ```

- 配置 `mod-fastdfs.conf`，并拷贝到 `/etc/fdfs` 文件目录下。
  
  ```bash
  cd /path/to/fastdfs-nginx-module-master/src/
  vim mod_fastdfs.conf
  ```
- 修改mod-fastdfs.conf配置只需要修改我标注的这三个地方就行了，其他不需要也不建议改变。
  
  ```bash
  # FastDFS tracker_server can ocur more than once, and tracker_server format is
  #  "host:port", host can be hostname or ip address
  # valid only when load_fdfs_parameters_from_tracker is true
  tracker_server=192.168.198.129:22122
  
  # if the url / uri including the group name
  # set to false when uri like /M00/00/00/xxx
  # set to true when uri like ${group_name}/M00/00/00/xxx, such as group1/M00/xxx
  # default value is false
  url_have_group_name = true

  # store_path#, based 0, if store_path0 not exists, it's value is base_path
  # the paths must be exist
  # must same as storage.conf
  store_path0=/data/fastdfs/storage
  #store_path1=/home/yuqing/fastdfs1
  ```
- 192.168.198.129 是 Tracker 服务器 IP 地址
- 接着我们需要把 fastdfs 下面的配置中还没有存在 `/etc/fdfs` 中的拷贝进去
  
  ```bash
  cp mod_fastdfs.conf /etc/fdfs/
  cp anti-steal.jpg http.conf mime.types /etc/fdfs/
  ```

### 修改 Nginx 配置文件
- 在配置文件中加入：
  
  ```bash
  location /group1/M00 {
    root /data/fastdfs/storage/;
    ngx_fastdfs_module;
    }
  ```
- 由于我们配置了 `group1/M00` 的访问，我们需要建立一个 group1 文件夹，并建立 M00 到 data 的软链接。
  
  ```bash
  mkdir /data/fastdfs/storage/data/group1
  ln -s /data/fastdfs/storage/data /data/fastdfs/storage/data/group1/M00
  ```
- 修改完nginx，重启nginx即可！
