## Nginx服务器设置上传文件大小限制
- 经同事反应，在nginx服务器上传大小200M的文件总是失败，后来检查nginx配置，发现nginx中并没有相关的配置，nginx默认上传文件大小为2M，那么怎样设置上传文件大小呢。
其实很简单，只需在配置文件中增加相关配置即可。
- 我是在http段加的相关配置，也可以在location段中增加相关配置。
- 具体配置信息如下：
  ``` conf
  client_max_body_size    1000m;
  ```
- 配置后重启nginx即可：
  ``` bash
  nginx -t
  nginx -s reload
  ```
