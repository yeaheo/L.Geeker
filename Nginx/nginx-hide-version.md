# Nginx-隐藏版本号
#### 未修改前：
  ``` xml
  [root@test-node1 ~]# curl -I http://127.0.0.1
  HTTP/1.1 302 Found
  Server: nginx/1.12.0
  Date: Sat, 22 Jul 2017 10:01:01 GMT
  Content-Type: text/plain; charset=utf-8
  Connection: keep-alive
  Location: /login
  Set-Cookie: grafana_sess=e7badd2607d1c42c; Path=/; HttpOnly
  Set-Cookie: redirect_to=%252F; Path=/
  ```
#### 修改nginx配置文件，默认在/usr/local/nginx/conf目录下
- `vim /usr/local/nginx/conf/nginx.conf`
- 在http{}段内添加`server_tokens off;`
- 重新加载nginx配置文件
  `nginx -s reload`
#### 修改后：
  ``` xml
  [root@test-node1 ~]# curl -I http://127.0.0.1
  HTTP/1.1 302 Found
  Server: nginx
  Date: Sat, 22 Jul 2017 10:05:25 GMT
  Content-Type: text/plain; charset=utf-8
  Connection: keep-alive
  Location: /login
  Set-Cookie: grafana_sess=1433bef4a430a2b2; Path=/; HttpOnly
  Set-Cookie: redirect_to=%252F; Path=/
  ```
  

