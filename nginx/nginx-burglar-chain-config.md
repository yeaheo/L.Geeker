## Nginx 配置防盗链
- 盗链是一种损害原有网站合法利益，给原网站所在服务器造成额外负担的非法行为。要采取防盗链的措施，首先需要了解盗链的实现原理。 客户端向服务器请求资源时，为了减少网络带宽，提高响应时间，服务器一般不会一次将所有资源完整地传回给客户端。比如在请求一个网页时，首先会传回该网页的文本内容，当客户端浏览器在解析文本的过程中发现有图片存在时，会再次向服务器发起对该图片资源的请求，服务器将存储的图片资源再发送给客户端。在这个过程中，如果该服务器上只包含了网页的文本内容，并没有存储相关的图片资源，而是将图片资源链接到其他站点的服务器上去了，这就形成了盗链行为。
- Nginx 配置防盗链一般有三种方式，分别为对一般文件实施防盗链、对某一目录实施防盗链和利用第三方模块实施防盗链。下面分别配置这三种方式。

### Nginx 一般的防盗链
- Nginx 配置中有一个指令 `valid_referers` ，用来获取 `Referer` 头域中的值，并且根据该值的情况给 Nginx 全局变量 `$invalid_referer` 的值，如果 `Referer` 头域中没有符合 `valid_referers` 指令配置的值，`$invalid_referer` 变量将会被赋值为 1。

- 一般 Nginx 配置防盗链只需要修改 nginx 的配置文件 `nginx.conf` 添加如下内容：

  ```bash
  location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|mp4|flv)$ {
            valid_referers  *.test.com test.com *.qq.com *.baidu.com;
            if ($invalid_referer) {
                return 301  http://www.test.com;
            }
  }
  ```

- **配置说明：**
- `.*\.(gif|jpg|jpeg|png|bmp|swf|mp4|flv)$` ，设置防盗链文件类型，自行修改，每个后缀用 "|" 符号分开。
- `valid_referers` 配置白名单，允许文件链出的域名白名单，自行修改成您的域名。
- `return 301` 设置盗链后转到的地址。

  > 单纯图片防盗链时这里可以是盗链返回的图片，也就是替换盗链网站所有盗链的图片。这个图片要放在没有设置防盗链的网站上，因为防盗链的作用，这个图片如果也放在防盗链网站上就会被当作防盗链显示不出来了，盗链者的网站所盗链图片会显示X符号。

- 这样设置差不多就可以起到防盗链作用了。配置完成后，在浏览器直接输入图片/视频地址就不会再显示图片出来了，也不可能会再右键另存为什么的。

### Nginx 针对图片目录防止盗链
- 和配置一般防盗链类似，也是修改 nginx 的配置文件 `nginx.conf` 增加如下内容：

  ```bash
  location /img {
            alias  /data/images; 
            valid_referers  *.test.com test.com *.qq.com *.baidu.com;
            if ($invalid_referer) {
                return 403;
            }
  }
  ```

  > 上述内容只是举例说明，还需根据实际情况进行配置


### 使用第三方模块 ngx_http_accesskey_module 实现 Nginx 防盗链
- 此部分和 PHP 关系比较密切，暂不配置。