## Nginx配置HTTP方法
- 一般的WEB扫描器经常会提示这样的安全问题：OPIONTS/TRACE mothed enable.
- 熟悉HTTP协议的人一定不陌生，浏览器向服务提交数据有很多中方法，常用的只有GET和POST两种。HTTP早期的时候还有很多种HTTP方法，比如,PUT,DELETE,MOVE等等。如果使用了WebDAV的话，还会有更多。
- 这些HTTP方法在今天信息系统中使用非常少，某些特定的情况下，还会导致一些安全问题，所以，几乎所有的扫描器，都把除GET和POST之外的HTTP方法列为不安全的。
- nginx默认禁用了TRACE\OPTIONS\TRACE方法，但是保留了HEAD方法。目前倒没有像JBoss那样专门利用HEAD方法来发起的攻击。
- 如果需要禁用的话，可以在nginx.conf中server配置中添加如下代码:
  ``` conf
  if ($request_method !~ ^(GET|POST)$) {
            return 405;
        }
  ```
- 此方式是只允许GET和POST,其他的方法都禁止的。
- 然后重启Nginx即可。
