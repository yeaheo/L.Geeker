## Nginx跨域配置
- Nginx如果需要实现跨域只需在配置文件中加入以下内容即可开启跨域
  ``` bash
  add_header Access-Control-Allow-Origin *;
  ```
- `*`代表任何域都可以访问，当然也可以改成只允许某个域访问，如`Access-Control-Allow-Origin: https://yeaheo.com`
- 这样虽然配置了跨域请求，但貌似只是支持`GET、HEAD、POST、OPTIONS`请求，有时候需要发送`DELETE`请求，大多数情况下浏览器出于安全考虑会先发起`OPTIONS`请求
服务端接收到的请求方式就变成了`OPTIONS`由此就导致了服务器报`405 Method Not Allowed`
- 或者有时候会报`403 Response to preflight request doesn't pass access control check: No 'Access-Control-Allow-Origin' header is present on the requested resource. Origin 'null' is therefore not allowed access. The response had HTTP status code 403`
- 考虑到上述情况，我们需要在nginx中配置对`OPTIONS`请求进行处理,如下：
  ``` bash
  if ($request_method = 'OPTIONS') {
               add_header Access-Control-Allow-Origin *;
               add_header Access-Control-Allow-Methods GET,POST,PUT,DELETE,OPTIONS;
               add_header Access-Control-Allow-Headers Origin,x-requested-with,Content-Type,Accept,X-Cookie,secret-key,identity-id;
               return 204;
            }
  ```
- 上述配置是指当请求方式为OPTIONS时，设置Allow的响应头，重新处理这次请求。
- 在server{}段内添加如上配置后就可以允许`DELETE`等方法进行跨域访问
- 原理如上所述。

- **亲身经历**
- 我们开发针对FastDFS分布式文件系统自己写了个小项目，用于公司发布图片等问题，并自己写了一个上传图片的demo，当选择好图片后点击上传图片会报错`403`,具体
报错信息如下：
  ``` bash
  403 Response to preflight request doesn't pass access control check: No 'Access-Control-Allow-Origin' header is present on the requested resource. Origin 'null' is therefore not allowed access. The response had HTTP status code 403
  ```
- 这就是不允许跨域的问题
- **解决方案**
- 根据上述所述，我配置了Nginx的跨域和反向代理,完整配置如下：
  ``` bash
  location /fdfs {
            if ($request_method = 'OPTIONS') {
               add_header Access-Control-Allow-Origin *;
               add_header Access-Control-Allow-Methods GET,POST,PUT,DELETE,OPTIONS;
               add_header Access-Control-Allow-Headers Origin,x-requested-with,Content-Type,Accept,X-Cookie,secret-key,identity-id;
               return 204;
            }
            proxy_redirect off;
            proxy_pass_header Server;
            proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_pass http://127.0.0.1:8090/fdfs;
        }
  ```
- 配置完成，重启Nginx即可解决问题。
- 需要注意的是`Access-Control-Allow-Origin *`此项只能有一个配置，不能重复，否则也会报错。还有就是如果报错某个头部信息不允许，只需将不允许的方法添加到
`Access-Control-Allow-Headers`参数中即可
- 如我上述配置我允许了`Origin,x-requested-with,Content-Type,Accept,X-Cookie,secret-key,identity-id`等头部信息，因为这是开发项目中需要的几个重要的
头部信息。
