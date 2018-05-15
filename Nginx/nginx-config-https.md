### Nginx-配置SSL模块支持https

- 默认情况下ssl模块并未被安装，如果要使用该模块则需要在编译时指定–with-http_ssl_module参数，安装模块依赖于OpenSSL库和一些引用文件，通常这些文件并不在同一个软件包中。通常这个文件名类似libssl-dev。

#### 创建存放证书相关文件的目录
- `mkdir /usr/local/ssl`

#### 准备相关证书
- 创建服务器私钥，命令会让你输入一个口令：
  - `openssl genrsa -des3 -out server.key 1024`

- 创建签名请求的证书（CSR）：
  - `openssl req -new -key server.key -out server.csr`

- 在加载SSL支持的Nginx并使用上述私钥时除去必须的口令：
  - `cp server.key server.key.org`
  - `openssl rsa -in server.key.org -out server.key`

- 最后标记证书使用上述私钥和CSR：
  - `openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt`

#### 配置Nginx
- Nginx配置文件
  ``` xml
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
  ``` xml
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
  
    
