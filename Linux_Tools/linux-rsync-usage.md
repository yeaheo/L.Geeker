## Linux-rsync工具的应用
- 作为一个运维工程师，经常可能会面对几十台、几百台甚至上千台服务器，除了批量操作外，环境同步、数据同步也是必不可少的技能。
- 说到“同步”，不得不提的利器就是rsync。rsync不但可以在本机进行文件同步，也可以作为远程同步工具
- 你可以使用他进行本地数据或者远程数据的复制，Rsync可以使用SSH隧道进行加密数据传输，Rsync服务器端定义源数据，Rsync客户端仅在源数据发生改变后才会从服务器上实际复制数据至本地，如果源数据在服务器上被删除，则客户端数据也会被删除，以确保主机之间的数据是同步的。
- Rsync使用TCP 873端口

### 搭建Rsync服务器
- `yum -y install rsync`

### 关于rsync的应用
- rsync同步命令中常用的几个参数说明：
  -
  - `-a`, --archive 归档模式，表示以递归方式传输文件，并保持所有文件属性，等于-rlptgoD
  - `-v`, --verbose 详细模式输出
  - `-p`, --perms 保持文件权限
  - `-g`, --group 保持文件属组信息
  - `-o`, --owner 保持文件属主信息
  - `-r`, --recursive 对子目录以递归模式处理。同步目录的时候要加上这个参数
  - `-l`, --links 保留软链结，加上这个参数，同步过来的文件会保持之前的软链接属性不变
  - `-H`, --hard-links 保留硬链结
  - `-e`, --rsh=COMMAND 指定使用rsh、ssh方式进行数据同步
  - `-z`, --compress 对备份的文件在传输时进行压缩处理
  - `--stats` 给出某些文件的传输状态
  - `--progress` 打印同步的过程
  - `--timeout=TIME` 同步过程中，IP超时时间，单位为秒
  - `--delete` 删除那些目标目录中有而源目录中没有的多余文件。这个是rsync做增量方式的全备份的最佳选择方案！！！！！！
  - `--delete-before` 接受者在输出之前进行删除操作。即先将目标目录中文件全部删除，再将源目录文件拷贝过去。这是rsync保持目标目录跟源目录一致的方案！！！
  - `--delete-after` 在同步操作之后做比较，删除那些目标目录中有而源目录中没有的多余文件
  - `--delete-excluded` 删除目标目录中那些被该选项指定排除的文件
  - `--ignore-errors` 即使出现IO错误也进行删除，忽略错误
  - `--exclude` 指定同步时需要过滤掉的文件或子目录(即不需要同步过去的)，后面直接跟不需要同步的单个文件名或子目录(不需要跟路径) ，过滤多个文件或子目录，  就使用多个--exclude
  - `--exclude-from` 指定同步时需要过滤掉的文件或子目录，后面跟文件(比如/root/exclue.txt)，然后将不需要同步的文件和子目录放到/root/exclue.txt下。
  - `--version` 打印版本信息
  - `--port=PORT` 指定其他的rsync服务端口
  - `--log-format=formAT` 指定日志文件格式
  - `-password-file=FILE` 从FILE中得到密码
  - `-bwlimit=KBPS` 限制I/O带宽，KBytes per second
### 通常用到的rsync的命令
- 2222是SSH服务端口
  - `rsync -e "ssh -p2222" -avpoglr /opt/soft/ 192.168.8.131:/opt/data/app`
- rsync如何实现同步目标路径下的目录,不同步路径下的文件，只是同步目录结构
  - `rsync -av --delete -f '+ */' -f '- *' SRC/ DEST/`
- rsync在远程同步的时候，要求目标目录要和源目录保持同步，目标目录中多余的文件都要删除,这就需要用到了参数`--delete`
  - `rsync -vlzrtogp --progress --delete root@192.168.1.120::test --password-file=/root/192.168.1.115 /root/2013/`
  - 但是这个--delete加上去就是一个危险的命令，因为它是在同步之前先将目标目录中的文件删除，然后再将源目录中的文件同步过去。如果目标目录比较大，在删除过程中出现宕机事故就不好了。所以最好还是用--delete-before或--delete-after比较温柔点，靠谱点
- rsync远程拷贝的时候，过滤某些某个文件或多个文件就用“--exclude 文件名”,要是过滤多个文件或子目录，就把过滤的文件或目录名的关键字放在一个文件里，如下的exclude_file文件,然后使用--exclude-from exclude—-file文件进行过滤
  - 相关备份脚本如下（仅供参考）
    ``` xml
    #!/bin/bash
    # Description: Rsync file
    # Author: Lv Xiaoteng
    # Email: <yeah6066@gmail.com>
    # Date: 2017-08-14
    # Version: 1.0
    
    # 添加需要过滤的文件
    EXCLUDE_FILE="/opt/file/exclude"
    # 设定相关变量
    SOURCE_DIR=/opt/backup/tar
    DEST_DIR=/opt/soft
    REMOTE_IP=6.6.6.12
    USER=root
    
    # password file must not be other-accessible.
    PASS_FILE=/root/rsync.pass
    
    # if the DEST_DIR not found,then create one
    [ ! -d $DEST_DIR ] && mkdir $DEST_DIR
    [ ! -d $PASS_FILE ] && exit 2
    
    # 开始同步
    #/usr/bin/rsync -e "ssh -p22" -avpgolr --exclude-from $EXCLUDE_FILE $SOURCE_DIR $REMOTE_IP:$DEST_DIR
    /usr/bin/rsync -azpgolr --delete --password-file=$PASS_FILE ${USER}@${REMOTE_IP}::$SOURCE_DIR $DEST_DIR/$(date +%Y%m%d)
    ```
  - 相关备份脚本如下（仅供参考）
    ``` xml
    #!/bin/bash
    # Description: Rsync file
    # Author: Lv Xiaoteng
    # Email: <yeah6066@gmail.com>
    # Date: 2017-08-14
    
    # 添加需要过滤的文件
    EXCLUDE_FILE="/opt/file/exclude"
    # 设定相关变量
    SOURCE_DIR=/opt/backup/tar
    DEST_DIR=/opt/soft
    REMOTE_IP=6.6.6.12
    
    # 开始同步
    /usr/bin/rsync -e "ssh -p22" -avpgolr --exclude-from $EXCLUDE_FILE $SOURCE_DIR $REMOTE_IP:$DEST_DIR
    ```
    
