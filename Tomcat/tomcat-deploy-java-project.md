## 同一个 Tomcat 下部署多个项目

### 在同一个 tomcat 下（即同一个端口）有两种方式：
- 第一种：共用同一个域名下的多个子项目
- 第二种：不同域名下的项目

- tomcat多项目部署，需要用到下面一行：
  ```xml
  <Context path="" docBase="/var/tomcat/www" debug="0" reloadable="true" />
  ```
- path后的""内填写的是项目名称，如果""为空，则表示是父项目（父项目情况下，这个Context行可以省略）

### 同一个域名下的多项目部署，配置如下：
- 配置文件如下所示：（Context行的位置放在"className"区域的下面）
  ```xml
  ......
        <Host name="www.test.com" appBase="webapps"
            unpackWARs="true" autoDeploy="true">
  ......
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
                  prefix="localhost_access_log." suffix=".txt"
                  pattern="%h %l %u %t &quot;%r&quot; %s %b" />
       <Context path="/test1" reloadable="true" docBase="/usr/local/tomcat7/test1"/> 
       <Context path="/test2" reloadable="true" docBase="/usr/local/tomcat7/test2"/> 
  </Host> 
  ......
  ```
- 由上面的配置可以看出
- 父项目是 <http://www.test.com/8080/test>,站点目录是 `/usr/local/tomcat7/webapps`，由于 webapps 下不是默认的 ROOT ，而是 test 。所以访问的 url 里要带 test
- 两个子项目分别是：
- <http://www.test.com:8080/test1>，对应的站点目录是 `/usr/local/tomcat7/test1`
- <http://www.test.com:8080/test2>，对应的站点目录是 `/usr/local/tomcat7/test2`

### 不同域名下的多项目部署
- 修改配置文件如下：
  ```xml
  ......
        <Host name="localhost" appBase="webapps" 
                  unpackWARs="true" autoDeploy="true">

        <!-- SingleSignOn valve, share authentication between web applications
            Documentation at: /docs/config/valve.html -->
       <!--
       <Valve className="org.apache.catalina.authenticator.SingleSignOn" />
       --> 

       <!-- Access log processes all example.
             Documentation at: /docs/config/valve.html
             Note: The pattern used is equivalent to using pattern="common" -->
         <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
                  prefix="localhost_access_log." suffix=".txt"
                  pattern="%h %l %u %t &quot;%r&quot; %s %b" />

         <Host name="www.beijing.com" appBase="apps"
                  unpackWARs="true" autoDeploy="true">

       <!-- SingleSignOn valve, share authentication between web applications
               Documentation at: /docs/config/valve.html -->
       <!--
       <Valve className="org.apache.catalina.authenticator.SingleSignOn" />
       -->

       <!-- Access log processes all example.
              Documentation at: /docs/config/valve.html
              Note: The pattern used is equivalent to using pattern="common" -->
         <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
                    prefix="localhost_access_log." suffix=".txt"
                    pattern="%h %l %u %t &quot;%r&quot; %s %b" />

         <Host name="www.wangshibo.com" appBase="wang"
                 unpackWARs="true" autoDeploy="true">

       <!-- SingleSignOn valve, share authentication between web applications
               Documentation at: /docs/config/valve.html -->
       <!--
       <Valve className="org.apache.catalina.authenticator.SingleSignOn" />
       -->

       <!-- Access log processes all example.
              Documentation at: /docs/config/valve.html
              Note: The pattern used is equivalent to using pattern="common" -->
         <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="localhost_access_log." suffix=".txt"
               pattern="%h %l %u %t &quot;%r&quot; %s %b" />
         <Context path="/ops1" reloadable="true" docBase="/data/web/ops1"/> 
         <Context path="/ops2" reloadable="true" docBase="/data/web/ops2"/>
  ```
