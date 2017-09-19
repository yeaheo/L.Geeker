## Nginx-配置proxy_set_header支持下划线
- nginx反向代理proxy_set_header自定义header头无效的问题

- 解决思路：
- 修改nginx配置文件，在http段添加`underscores_in_headers on;`默认为off。

- `vim /usr/local/nginx/conf/nginx.conf`
  ``` xml
  sendfile        on;
  #tcp_nopush     on;

  #keepalive_timeout  0;
  keepalive_timeout  65;
  underscores_in_headers on;
  ```
