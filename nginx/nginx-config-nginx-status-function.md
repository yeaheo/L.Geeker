# nginx-status开启状态查看功能及参数说明
- 本模块在编译的时候默认是不编译的,如果是从源码编译安装的nginx,那么需要在`./configure`编译的时候加上对应的模块 `--with-http_stub_status_module`
- 使用 `./configure --help` 能看到更多的模块支持,然后编译安装即可
- 使用 `nginx -V` 命令可以查看在编译安装的时候使用了哪些模块

- 修改 Nginx 配置文件，在 server 段内添加如下内容:
  
  ```bash
  location /nginx-status {
     stub_status on;
     access_log off;
     allow 127.0.0.1;                       
     deny all;
     }
  ```
- 重启 Nginx 服务
  
  ```bash
  nginx -s reload
  ```
  
- 测试访问地址
  
  ```bash
  curl http://127.0.0.1/nginx-status
  ```
- 结果如下所示:
  
  ```bash
  Active connections: 11921
  server accepts handled requests
  113    113     116
  Reading: 0 Writing: 7 Waiting: 42
  ```
- 参数说明：
  
  ```bash
  active connections               #活跃的连接数量
  server accepts handled requests  #总共处理了113个连接 , 成功创建113次握手, 总共处理了116个请求
  reading                          #读取客户端的连接数
  writing                          #响应数据到客户端的数量
  waiting                          #开启 keep-alive 的情况下,这个值等于 active – (reading+writing), 意思就是 Nginx 已经处理完正在等候下一次请求指令的驻留连接
  ```
