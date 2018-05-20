## FastDFS 上传及下载测试

#### 上传测试
- 完成上面的步骤后，我们已经安装配置完成了全部工作，接下来就是测试了。因为执行文件全部在 `/usr/bin`目录下，我们切换到这里，并新建一个 test.txt 文件，随便写一点什么，我写了 This is a test file. by:mafly 这句话在里边。然后测试上传：
   
   ```bash
   cd /usr/bin
   echo "This is a test file. by:mafly" > test.txt
   ```

#### 编辑 client.conf 文件
- 编辑 client.conf 文件, 修改如下配置：
  
  ```bash
  cd /etc/fdfs
  cp client.conf.sample client.confvim client.conf
  ```
- 修改如下参数：
- ![Client 修改配置文件](../images/Client.png)

#### 上传命令
- 上传文件测试：
  
  ```bash
  /usr/bin/fdfs_test /etc/fdfs/client.conf upload /usr/bin/test.txt
  ```
- 上传成功后会返回一个 url，将返回的 url 用浏览器访问即可实现下载


  
