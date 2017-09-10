## Nginx-设置上传文件大小限制
- Nginx默认不支持上传特别大的文件，所以当我们需要上传文件大小时需要修改一下Nginx的配置文件。
- 注：Nginx的安装方式为源码安装，安装目录为`/usr/local/nginx`
- 修改Nginx配置文件，具体配置如下：
- `# vim /usr/local/nginx/conf/nginx.conf`

- 在`http`或者`server`段中添加
- `client_max_body_size 100m;`
- 区别如下：
- 在`http`段中添加后，所有的server都生效。
- 在`server`段中添加后，只是添加的server生效。
- 添加好后，重启Nginx即可：
- `nginx -s reload`
