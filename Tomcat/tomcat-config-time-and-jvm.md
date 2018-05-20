## Tomcat 配置时间和 JVM

### Tomcat 配置之修改正确时间
- 有时候 Tomcat 日志输出的时间和服务器本身时间相差整整 8 小时，下面是修改方法。
- 修改 tomcat 所在目录的 `catalina.sh` 相关文件
  
  ```bash
  vim catalina.sh
  ```

- 在此文件中添加如下选项,重启 tomcat 即可。
  
  ```sh
  export JAVA_OPTS="$JAVA_OPTS -Duser.timezone=GMT+08"
  ```

### Tomcat 配置之 JVM 优化
- 有时候我们也需要修改 tomcat 的相关内存，在此也做一个整理
- 修改 tomcat 所在目录的 `catalina.sh` 相关文件
  
  ```bash
  vim catalina.sh
  ```
- 在此文件中添加如下选项,重启 tomcat 即可。
  
  ```sh
  export JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8 -server -Xms1024m -Xmx1024m -Duser.timezone=GMT+08"
  ```
- 这是为 tomcat 分配了一个G的内存的模板，其他类似
- **相关参数说明：**
- `-Dfile.encoding`：默认文件编码
- `-server`：表示这是应用于服务器的配置，JVM 内部会有特殊处理的
- `-Xmx1024m`：设置 JVM 最大可用内存为 1024MB。
- `-Xms1024m`：设置 JVM 最小内存为 1024m。此值可以设置与 `-Xmx` 相同，以避免每次垃圾回收完成后 JVM 重新分配内存。
  
