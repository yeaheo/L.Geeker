## Tomcat-自定义过滤器
- 有时我们扫描漏洞时提示我们缺少 `X-Frame-Options`头，在 tomcat 中配置如下：
- 修改 `web.xml`文件，添加如下内容，重启 tomcat 即可：

  ```xml
  <filter>
        <filter-name>httpHeaderSecurity</filter-name>
        <filter-class>org.apache.catalina.filters.HttpHeaderSecurityFilter</filter-class>
        <init-param>
        <param-name>antiClickJackingEnabled</param-name>
        <param-value>true</param-value>
        </init-param>
        <init-param>
        <param-name>antiClickJackingOption</param-name>
        <param-value>SAMEORIGIN</param-value>
        </init-param>
        <async-supported>true</async-supported>
   </filter>
   <filter-mapping>
        <filter-name>httpHeaderSecurity</filter-name>
        <url-pattern>/*</url-pattern>
        <dispatcher>REQUEST</dispatcher>
   </filter-mapping>
   ```
