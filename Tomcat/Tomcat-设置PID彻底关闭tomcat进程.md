## 通过设置PID彻底关闭TOMCAT相关进程
- 在很多时候我们会发现用tomcat自带的关闭脚本关闭tomcat后，Tomcat的相关进程还是会存在的，这时候我们需要强制关闭tomcat，操作方法如下：


- 首先，需要修改catalina.sh脚本，在“PRGDIR=`dirname "$PRG"`”下添加如下内容，获取进程PID
  ``` xml
  if [ -z "$CATALINA_PID" ]; then

      CATALINA_PID=$PRGDIR/CATALINA_PID

  fi
  ```

- 然后修改shutdown.sh文件
  - `vim /path/to/bin/shutdown.sh`
  - 修改`exec "$PRGDIR"/"$EXECUTABLE" stop"$@"`
  - 为
  - `exec "$PRGDIR"/"$EXECUTABLE" stop -force"$@"`

- 这样就可以强制关闭tomcat进程了
