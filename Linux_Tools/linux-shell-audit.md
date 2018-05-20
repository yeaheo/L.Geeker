## 优化 Shell 操作审计
- 在 Linux 下面可以使用 `history` 命令查看用户的所有历史操作，同时 `shell` 命令操作记录默认保存在用户目录的 `.bash_history` 文件中。通过这个文件可以查询 `shell` 命令的执行历史，有助于运维人员进行系统审计和问题排查，同时在服务器遭受黑客攻击后，也可以查询黑客登录服务器的历史命令操作。但是黑客在入侵后，为了抹除痕迹，会删除`.bash_history`文件，这个就需要合理备份这个文件了。
- 默认的 history 命令只能查看用户的历史操作记录，但是不能区分每个用户操作命令的时间。这点对于问题排查相当的不方便。
- 下面我们就要配置一下 Shell 审计功能，配置完成后效果如下所示：
  
  ```bash
  ......
  root(root)@(192.168.8.153) [LOGIN:2017-11-13 18:15 .] --- 2017/11/13 18:37:05 vim README.md
  ......
  ```

### 配置 Shell 审计功能
- 编辑 `/etc/profile` 文件，在最后增加如下内容：

  ```sh
  HISTTIMEFORMAT="%Y/%m/%d %T ";export HISTTIMEFORMAT
  export HISTORY_FILE=/var/log/audit.log  #记录存放位置
  export PROMPT_COMMAND='{ thisHistID=`history 1|awk "{print \\$1}"`;lastCommand=`history 1| awk "{\\$1=\"\" ;print}"`;user=`id -un`;whoStr=(`who -u am i`);realUser=${whoStr[0]};logMonth=${whoStr[2]};logDay=${whoStr[3]};logTime=${whoStr[4]};ip=${whoStr[6]};if [ ${thisHistID}x != ${lastHistID}x ];then echo -E $user\($realUser\)@$ip [LOGIN:$logMonth $logDay $logTime] --- $lastCommand ;lastHistID=$thisHistID;fi; } >> $HISTORY_FILE'
  ```
- 有时候会遇到权限问题，所以我们需要配置一下 `/var/log/audit.log` 文件的权限。
  
  ```bash
  touch /var/log/audit.log
  chown nobody.nobody /var/log/audit.log
  chmod 002 /var/log/audit.log
  ```

- 修改完成刷新即可
  
  ```bash
  source /etc/profile
  ```
