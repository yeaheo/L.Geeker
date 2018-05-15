# Tomcat配置上下文
- 目前tomcat配置上下文一共有三种方式：
  - 1、位于webapps文件夹中的web项目，无需指定Context，Tomcat默认解析Context为该web项目根文件夹的名称，即为真实目录名称。
  - 2、在server.xml中指定Context。 编辑conf/server.xml文件，在<host>元素之间加入子元素。
  - 3、创建*.xml文件指定Context。 在conf/Catalina/localhost文件夹中创建xml文件，文件名为“虚拟目录名称”+“.xml”。

### 具体配置方法
- 第一种方式是默认的。
- 第二种是编辑conf/server.xml文件，添加如下内容到<host>元素之间。
  ``` xml
  vim /usr/local/tomcat/conf/server.html
  
  <Context docBase=”web项目根文件夹的文件路径” path=”/虚拟目录名称”/>
  ```
  ``` xml
  <Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
        <Context path="" docBase="xszs" reloadable="false"/>
  ```
- 第三种方式就是单独在`conf/Catalina/localhost`创建一个xml文件,内容如下：
  ``` xml
  <Context docBase=”web项目根文件夹的文件路径” path=”/虚拟目录名称”/>
  ```
  
