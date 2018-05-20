## Nginx 配置 HTTP 方法
- 一般的WEB扫描器经常会提示这样的安全问题：`OPIONTS/TRACE mothed enable`.
- 熟悉 HTTP 协议的人一定不陌生，浏览器向服务提交数据有很多中方法，常用的只有 GET 和 POST 两种。HTTP 早期的时候还有很多种 HTTP方法，比如, PUT , DELETE , MOVE 等等。如果使用了 WebDAV 的话，还会有更多。
- 这些 HTTP 方法在今天信息系统中使用非常少，某些特定的情况下，还会导致一些安全问题，所以，几乎所有的扫描器，都把除 GET 和 POST 之外的 HTTP 方法列为不安全的。
- nginx 默认禁用了 TRACE\OPTIONS\TRACE 方法，但是保留了 HEAD 方法。目前倒没有像 JBoss 那样专门利用 HEAD 方法来发起的攻击。
- 如果需要禁用的话，可以在 `nginx.conf中server`配置中添加如下代码:
  
  ```bash
  if ($request_method !~ ^(GET|POST)$) {
            return 405;
        }
  ```
- 此方式是只允许 GET 和 POST,其他的方法都禁止的。
- 然后重启Nginx即可。
