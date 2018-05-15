## Nginx反向代理时的超时问题
- 本文接上一篇文档[描述](Nginx-反向代理时的超时问题(描述).md)
### websocket 1分钟会自动断开问题
- location 中的proxy_read_timeout 默认60s断开，可以把他设置大一点,或者配置在server或者http段内均可。
- 例如：
- location段
  ``` conf
  location / {
      add_header X-Frame-Options SAMEORIGIN;
      add_header X-Content-Type-Options nosniff;
      add_header X-XSS-Protection "1; mode=block";
      proxy_connect_timeout 60s; ▲
      proxy_read_timeout 3600s;  ▲
      proxy_send_timeout 60s;    ▲
      proxy_pass_header Server;
      proxy_set_header Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Scheme $scheme;
      proxy_pass http://127.0.0.1:8080;
      }
  ```
- server段
  ``` conf
  ....
  server {
        listen       80;
        server_name  localhost;
        proxy_connect_timeout 60s; ▲
        proxy_read_timeout 3600s;  ▲
        proxy_send_timeout 60s;    ▲
        #charset koi8-r;
        include /usr/local/nginx/conf.d/*.conf;
        ....
   }
   ```
- http段
  ``` conf
  http {
  .....
  proxy_connect_timeout 60s; ▲
  proxy_read_timeout 3600s;  ▲
  proxy_send_timeout 60s;    ▲
  ....
  }
  ```
- 修改完毕，重启nginx即可。
  
