## tomcat 配置上下文

- 目前tomcat配置上下文一共有三种方式：
- 1、位于 `webapps` 文件夹中的 `web` 项目，无需指定 `context`，`tomcat` 默认解析 `context` 为该 `web` 项目根文件夹的名称，即为真实目录名称。
- 2、在 `server.xml`中指定 `context`。 编辑 `conf/server.xml`文件，在 `<host>` 元素之间加入子元素。
- 3、创建`*.xml`文件指定 context。 在 `conf/Catalina/localhost` 文件夹中创建 xml 文件，文件名为“虚拟目录名称”+“.xml”。

### 具体配置方法
- 第一种方式是默认的。

- 第二种是编辑 `conf/server.xml` 文件，添加如下内容到 `<host>` 元素之间。
  
  ```xml
  vim /usr/local/tomcat/conf/server.html
  
  <Context docBase=”web项目根文件夹的文件路径” path=”/虚拟目录名称”/>
  ```
- 例如
  
  ```xml
  <Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
        <Context path="" docBase="xszs" reloadable="false"/>
  ```

- 第三种方式就是单独在 `conf/Catalina/localhost` 创建一个xml文件,内容如下：
  
  ```xml
  <Context docBase=”web项目根文件夹的文件路径” path=”/虚拟目录名称”/>
  ```
  
