## 通过设置 PID 彻底关闭 TOMCAT 相关进程
- 在很多时候我们会发现用 tomcat 自带的关闭脚本关闭 tomcat 后，Tomcat 的相关进程还是会存在的，这时候我们需要强制关闭 tomcat，操作方法如下：


- 首先，需要修改 `catalina.sh`脚本，在 `“PRGDIR=`dirname "$PRG"`”` 下添加如下内容，获取进程 PID
  
  ```bash
  if [ -z "$CATALINA_PID" ]; then

      CATALINA_PID=$PRGDIR/CATALINA_PID

  fi
  ```

- 然后修改 `shutdown.sh`文件
  ```bash
  vim /path/to/bin/shutdown.sh
  ```
- 修改`exec "$PRGDIR"/"$EXECUTABLE" stop"$@"` 为 `exec "$PRGDIR"/"$EXECUTABLE" stop -force"$@"`

- 这样就可以强制关闭 tomcat 进程了
