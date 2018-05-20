## Nginx-配置SSL模块支持https

- 默认情况下 ssl 模块并未被安装，如果要使用该模块则需要在编译时指定 `--with-http_ssl_module` 参数，安装模块依赖于 OpenSSL 库和一些引用文件，通常这些文件并不在同一个软件包中。通常这个文件名类似 libssl-dev。

### 创建存放证书相关文件的目录
- 新建一个目录用于存放证书相关文件：
  
  ```bash
  mkdir /usr/local/ssl
  ```

### 准备相关证书
- 创建服务器私钥，命令会让你输入一个口令：
  
  ```bash
  openssl genrsa -des3 -out server.key 1024
  ```

- 创建签名请求的证书（CSR）：
  
  ```bash
  openssl req -new -key server.key -out server.csr
  ```

- 在加载 SSL 支持的 Nginx 并使用上述私钥时除去必须的口令：
  ```bash
  cp server.key server.key.org
  openssl rsa -in server.key.org -out server.key
  ```

- 最后标记证书使用上述私钥和 CSR：
  
  ```bash
  openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
  ```

### 配置 Nginx
- Nginx 配置文件
  
  ```bash
  server {
        listen       443 ssl;
        server_name  www.yeaheo.com;
        ssl_certificate      /usr/local/ssl/server.crt;
        ssl_certificate_key  /usr/local/ssl/server.key;
        ssl_session_timeout  5m;
        location / {
            root   html;
            index  index.html index.htm;
        }
    }
  ```
- 配置地址跳转
  
  ```bash
  server {
        listen       80;
        server_name  www.yeaheo.com;
        return 301 https://$server_name$request_uri;
        charset utf-8;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }
  ```
  
    
