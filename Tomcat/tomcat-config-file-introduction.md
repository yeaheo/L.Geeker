## Tomcat的配置文件大概内容如下
``` xml
.......
<Connector port="8066" URIEncoding="UTF-8" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
.......
<Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
.......
```
- `URIEncoding="UTF-8"`默认是没有的，保证tomcat的编码是UTF-8

#### Tomcat默认站点目录
- tomcat的默认站点根目录是webapps/ROOT，配置文件是server.xml
- 配置文件内容如上所示
- 如果代码的war包名称是ROOT.war，那么tomcat重启后，访问站点的根目录就是webapps/ROOT,访问url是http://localhost:8080 （ROOT目录，在访问时的url中可以省略）
- 如果代码的war包名次不是ROOT.war，比如是jenkins.war，那么tomcat重启后，访问站点的根目录就是webapps/jenkins，访问url就是http://localhost:8080/jenkins （非ROOT目录，在访问时的url中必须要带上）

#### 修改默认域名
- 如下，只修改"Host name"处，将默认的localhost修改为www.test.com
``` xml
.......
<Connector port="8066" URIEncoding="UTF-8" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
.......
<Host name="www.test.com"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
.......
```
- 那么此tomcat站点访问地址是：http://www.test.com:8066/test

#### 修改tomcat访问的默认站点目录
- 如下配置,重启tomcat后,会把tomcat默认站点目录改为/var/tomcat/www这个目录
``` xml
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
- 这里的appBase后填写的是新的站点根目录，也可以还设置成webapps，若是webapps，则下面的Context一行必须设置
- Context这一行最好添加上，path后面的""里配置的是tomcat的子项目，""为空，表示是父项目
- 注意：
``` xml
1\上面的appBase可以配置成新的站点目录，这时下面的Context这一行配置可以不加。
默认站点目录webapps下还是会产生代码目录，只是tomcat访问的时候不会去调用它
2\上面的appBase可以配置成默认的webapps站点目录，这种情况下，就必须添加Contest这一行，并在Context行内配置新的站点目录
3\Context这一行是tomcat的项目配置，path后的""内填写的是项目名称，如果""为空，则表示是父项目.
Context这一行的配置：
在appBase配置成新的站点目录的情况下可有可无（不过建议最好还是配置上）
在appBase配置成默认的webapps目录的情况下就必须要有！
```
- 所以配置文件内容可以是以下两种：
``` xml
<Host name="www.test.com" appBase="/var/tomcat/www"
      unpackWARs="true" autoDeploy="true">
```
``` xml
<Host name="www.test.com" appBase="webapps"
      unpackWARs="true" autoDeploy="true">
<Context path="" docBase="/var/tomcat/www" debug="0" reloadable="true" />
```
