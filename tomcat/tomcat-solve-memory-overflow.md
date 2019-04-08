## Tomcat-内存溢出相关

- Tomcat常见的内存溢出问题有三种：
- 1.OutOfMemoryError： Java heap space
- 2.OutOfMemoryError： PermGen space
- 3.OutOfMemoryError： unable to create new native thread

- Tomcat 默认可以使用的内存为 128MB，在较大型的应用项目中，这点内存显然是不够的，从而有可能导致系统无法运行！
- 其中常见的内存问题是报 Tomcat 内存溢出错误，Out of Memory(系统内存不足)的异常，从而导致客户端显示500错误
- 在生产环境中，tomcat 内存设置不好很容易出现 JVM 内存溢，解决方法如下：
- 修改 tomcat 中的 `catalina.sh` 文件，添加相关参数
  ```bash
  vim $TOMCAT_HOME/bin/catalina.sh
  ```
  
  ```sh
  ......
  JAVA_OPTS="-Xms1024m -Xmx1024m -XX:PermSize=256M -XX:MaxNewSize=512m -XX:MaxPermSize=512m"
  ......
  ```
- 其中，`-Xms` 表示初始化内存大小，`-Xmx` 表示最大内存大小，一般两者设置大小一样。
- 最后，重启 tomcat 即可生效。
  
