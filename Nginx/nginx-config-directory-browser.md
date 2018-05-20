## Nginx配置开启目录浏览功能
- 有时候我们需要将服务器上的某些目录共享出来，让其他人可以直接通过浏览器去访问、浏览或者下载这些目录里的一些文件。
- 现在有两种方法可以实现此功能：一是使用 Node 的 http-server ，二是使用 Nginx 自带的 `ngx_http_autoindex_module` 模块。
- 在这里我选择了更简单的第二种方法，即依赖 Nginx 自带的 `ngx_http_autoindex_module`模块。

### 开启目录浏览功能
- 要开启 Nginx 的目录浏览功能只需要打开 `nginx.conf` 或者对应的虚拟主机配置文件,在 `server` 或 `location` 段里面中加上 `autoindex on` 即可。
- 除了 autoindex 外，该模块还有两个可用的字段：

  ```bash
  autoindex_exact_size on;
  # 默认为 on，以 bytes 为单位显示文件大小
  # 切换为 off 后，以可读的方式显示文件大小，单位为 KB、MB 或者 GB
  ```
  ```bash
  autoindex_localtime on;
  # 默认为 off，以 GMT 时间作为显示的文件时间
  # 切换为 on 后，以服务器的文件时间作为显示的文件时间
  ```

- 除此之外，如果二级目录使用的是虚拟目录，则需要使用 alias 字段进行配置。

- 下面是一个完整的配置文件案例(仅供参考)
  
  ```bash
  location /download {
      alias /home/user/static_files/;   
      autoindex on;                     
      autoindex_exact_size off;         
      autoindex_localtime on;           
      }
  ```

### 开启密码保护功能
- 如果该目录是隐私目录，就需要为其增加密码保护。方法如下：
  
  ```bash
  location /download {
      # ... 其它同上
    
      auth_basic "Enter your name and password";
      auth_basic_user_file /var/www/html/.htpasswd;
  }
  ```
- `auth_basic`: 用户名、密码弹框上显示的文字；
- `auth_basic_user_file`: 指定了记录登录用户名与密码的文件，可以使用 htpasswd 工具来生成。
- 具体使用方法：
  
  ```bash
  # 创建一个全新的文件，会清除文件里的全部用户
  $ htpasswd -c /var/www/html/.htpasswd user1  
  
  # 添加一个用户，如果用户已存在，则修改密码
  $ htpasswd -b /var/www/html/.htpasswd user2 password
  
  # 删除一个用户
  $ htpasswd -D /var/www/html/.htpasswd user2
  ```
