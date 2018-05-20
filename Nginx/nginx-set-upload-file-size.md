## Nginx 设置上传文件大小限制
- Nginx 默认不支持上传特别大的文件，所以当我们需要上传文件大小时需要修改一下 Nginx 的配置文件。
  > Nginx 的安装方式为源码安装，安装目录为 `/usr/local/nginx`

- 修改 Nginx 配置文件，具体配置如下：
  
  ```bash
  vim /usr/local/nginx/conf/nginx.conf
  ```
- 在 `http` 或者 `server` 段中添加如下内容：
  
  ```bash
  client_max_body_size 100m;
  ```
- 在不同的段中添加是有区别的，具体说明如下：
- 在 `http` 段中添加后，所有的 server 都生效。
- 在 `server` 段中添加后，只是添加的 server 生效。
- 添加好后，重启 Nginx 即可：
  ```bash
  nginx -s reload
  ```

