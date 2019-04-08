## Nginx-配置 proxy_set_header 支持下划线
- nginx 反向代理 proxy_set_header 自定义 header 头无效的问题

- 解决思路：
- 修改 nginx 配置文件，在 http 段添加 `underscores_in_headers on;` 默认为off。

  ```bash
  vim /usr/local/nginx/conf/nginx.conf
  ```
  
  ```bash
  sendfile        on;
  #tcp_nopush     on;

  #keepalive_timeout  0;
  keepalive_timeout  65;
  underscores_in_headers on;
  ```
- 重启 nginx 服务即可：
  
  ```bash
  nginx -s reload
  ```