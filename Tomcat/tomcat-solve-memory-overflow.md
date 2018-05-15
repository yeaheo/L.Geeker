# Tomcat-内存溢出相关

- Tomcat常见的内存溢出问题有三种：
  - 1.OutOfMemoryError： Java heap space
  - 2.OutOfMemoryError： PermGen space
  - 3.OutOfMemoryError： unable to create new native thread

- Tomcat默认可以使用的内存为128MB，在较大型的应用项目中，这点内存显然是不够的，从而有可能导致系统无法运行！
- 其中常见的内存问题是报Tomcat内存溢出错误，Out of Memory(系统内存不足)的异常，从而导致客户端显示500错误
- 在生产环境中，tomcat内存设置不好很容易出现JVM内存溢，解决方法如下：
  - 修改tomcat中的catalina.sh文件，添加相关参数
  - `vim $TOMCAT_HOME/bin/catalina.sh`
  -
  ``` xml
  ......
  JAVA_OPTS="-Xms1024m -Xmx1024m -XX:PermSize=256M -XX:MaxNewSize=512m -XX:MaxPermSize=512m"
  ......
  ```
  -
  - 其中，`-Xms`表示初始化内存大小，`-Xmx`表示最大内存大小，一般两者设置大小一样。
  - 最后，重启tomcat即可生效。
  
