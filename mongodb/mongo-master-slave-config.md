## Mongo 的主从配置

- 关闭 Mongo 服务
  ```bash
  [root@localhost bin]# mongo
   MongoDB shell version: 3.2.10
   connecting to: test
   > use admin;
     switched to db admin
   > db.shutdownServer();
   或者：
   Ctrl+D
  ```
- 修改配置文件，在配置文件下添加如下(从节点)
  
  ```bash
  slave = true
  source = 192.168.8.127:27017
  ```
- 修改主节点配置文件
  
  ```bash
  master = true
  ```
- 分别启动主从节点的 Mongodb 服务即可，此时已实现 Mongodb 的主从复制
