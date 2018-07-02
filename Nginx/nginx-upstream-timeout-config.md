## Nginx 解决 upstream timeout 的问题
- 有时候我们用 nginx 做反向代理的时候会遇到如下报错：

  ```bash
  "[error] 11618#0: *324911 upstream timed out (110: Connection timed out) while reading response header from upstream, "
  ```

- 其实这是由于超时问题造成的，解决方案如下：

### Proxy 方式
- 一般我们用的是 nginx 的 proxy 机制做反向代理，此时我们需要修改 nginx 配置文件 `nginx.conf` ，在 http 或者 server 段添加如下内容：

  ```bash
  large_client_header_buffers 4 16k;
  client_max_body_size 30m;
  client_body_buffer_size 128k;
  
  proxy_connect_timeout 300;
  proxy_read_timeout 300;
  proxy_send_timeout 300;
  proxy_buffer_size 64k;
  proxy_buffers   4 32k;
  proxy_busy_buffers_size 64k;
  proxy_temp_file_write_size 64k;
  ```

- 然后重启 nginx ，一般超时问题就会解决了。

### Fastcgi 方式
- 大多数情况下我们用的是 proxy 方式，但是有时候我们还会遇到 fastcgi 的方式，例如用 nginx 处理 php。其实处理方式类似，同样是修改 nginx 配置文件 `nginx.conf` ,在 http 或者 server 段添加如下内容：

  ```bash
  large_client_header_buffers 4 16k;
  client_max_body_size 30m;
  client_body_buffer_size 128k;
  
  fastcgi_connect_timeout 300;
  fastcgi_read_timeout 300;
  fastcgi_send_timeout 300;
  fastcgi_buffer_size 64k;
  fastcgi_buffers   4 32k;
  fastcgi_busy_buffers_size 64k;
  fastcgi_temp_file_write_size 64k;
  ```

- 然后重启 nginx ，一般超时问题就会解决了。