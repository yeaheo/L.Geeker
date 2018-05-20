## Tomcat的配置文件大概内容如下
- tomcat 的默认配置文件内容如下：
  
  ```xml
  .......
  <Connector port="8066" URIEncoding="UTF-8" protocol="HTTP/1.1"
                 connectionTimeout="20000"
                 redirectPort="8443" />
  .......
  <Host name="localhost"  appBase="webapps"
              unpackWARs="true" autoDeploy="true">
  .......
  ```
  
  > `URIEncoding="UTF-8"` 默认是没有的，保证 tomcat 的编码是 UTF-8

#### Tomcat 默认站点目录
- tomcat 的默认站点根目录是 `webapps/ROOT`，配置文件是 `server.xml`
- 配置文件内容如上所示
- 如果代码的 war 包名称是 `ROOT.war`，那么tomcat重启后，访问站点的根目录就是 `webapps/ROOT`,访问 `url` 是 `http://localhost:8080` （ROOT 目录，在访问时的 url 中可以省略）
- 如果代码的 war 包名次不是 `ROOT.war`，比如是 `jenkins.war`，那么 tomcat 重启后，访问站点的根目录就是 `webapps/jenkins`，访问 url 就是 `http://localhost:8080/jenkins` （非 ROOT 目录，在访问时的 url 中必须要带上）

#### 修改默认域名
- 如下，只修改 "Host name" 处，将默认的 localhost 修改为 www.test.com
  
  ```xml
  .......
  <Connector port="8066" URIEncoding="UTF-8" protocol="HTTP/1.1"
                 connectionTimeout="20000"
                 redirectPort="8443" />
  .......
  <Host name="www.test.com"  appBase="webapps"
              unpackWARs="true" autoDeploy="true">
  .......
  ```
- 那么此 tomcat 站点访问地址是：http://www.test.com:8066/test

#### 修改 tomcat 访问的默认站点目录
- 如下配置,重启 tomcat 后,会把 tomcat 默认站点目录改为 `/var/tomcat/www` 这个目录
  
  ```xml
  .......
  <Connector port="8066" URIEncoding="UTF-8" protocol="HTTP/1.1"
                 connectionTimeout="20000"
                 redirectPort="8443" />
  .......
  <Host name="www.test.com"  appBase="/var/tomcat/www"
              unpackWARs="true" autoDeploy="true">
  <Context path="" docBase="/var/tomcat/www" debug="0" reloadable="true" />
  .......
  ```
- 这里的 appBase 后填写的是新的站点根目录，也可以还设置成 webapps，若是 webapps，则下面的 Context一行必须设置
- Context 这一行最好添加上，path 后面的""里配置的是 tomcat 的子项目，""为空，表示是父项目
- 注意：
  
  ```bash
  1.上面的appBase可以配置成新的站点目录，这时下面的Context这一行配置可以不加。
  默认站点目录webapps下还是会产生代码目录，只是tomcat访问的时候不会去调用它
  2.上面的appBase可以配置成默认的webapps站点目录，这种情况下，就必须添加Contest这一行，并在Context行内配置新的站点目录
  3.Context这一行是tomcat的项目配置，path后的""内填写的是项目名称，如果""为空，则表示是父项目.
  4.Context这一行的配置：
  在appBase配置成新的站点目录的情况下可有可无（不过建议最好还是配置上）
  在appBase配置成默认的webapps目录的情况下就必须要有！
  ```
- 所以配置文件内容可以是以下两种：
  
  ```xml
  <Host name="www.test.com" appBase="/var/tomcat/www"
        unpackWARs="true" autoDeploy="true">
  ```
  
  ```xml
  <Host name="www.test.com" appBase="webapps"
        unpackWARs="true" autoDeploy="true">
  <Context path="" docBase="/var/tomcat/www" debug="0" reloadable="true" />
  ```
