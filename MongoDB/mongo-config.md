## Mongo的日常使用及配置
- 当我们安装数据库后，需要使用，具体包括新建用户及数据库，并且给相关用户授权

### 远程连接
- 远程连接 mongo 服务端：
  
  ```bash
  mongo 192.168.13.225:27017
  ```
- mongo 后添加的是 Mongodb 服务器的 IP 和端口

### 新建用户
- 新建用户如下：
  
  ```bash
  > use admin
  > db.createUser({user:'yiwen',pwd:'mongo232!@#',roles:[{role:'dbOwner', db:'yiwen'}]})
  ```
### 创建一个不受访问限制的用户
- 创建一个不受访问限制的用户参考如下：
  
  ```bash
  > use admin
  > db.createUser(
    {
    user:"root",
    pwd:"admin@123",
    roles:["root"]
    }
    )
  ```

### 创建一个超级用户
- 超级用户的 role 有两种，userAdmin 和 userAdminAnyDatabase
  
  ```bash
  > use admin 
  > db.createUser( 
    {
     user: "yiwen",
     pwd: "mongo@abc!@#",
     roles:[
         {
              role: "dbOwner",
              db: "yiwen"
         }]
     }
     )
  ```

### 查看当前用户权限
- 查看当前用户相关权限：
  
  ```bash
  > db.runCommand(
    {
    usersInfo:"yiwen",
    showPrivileges:true
    }
  ```
  > 注：只能查看当前数据库中的用户，哪怕当前数据库admin数据库，也只能查看admin数据库中创建的用户

### 查看用户信息
- 查看相关用户信息：
  
  ```bash
  > db.runCommand({usersInfo:"userName"})
  ```

### 修改用户密码
- 修改用户账号密码：
  
  ```bash
  > use admin
  > db.changeUserPassword("username", "xxx")
  ```

### 建数据库(例子)
- 新建数据库参考如下示例：
  
  ```bash
  > use admin；
  > db.auth("yiwen","mongo126!@#")；
  > use yiwen;
  > db.createCollection('_sequeue');
    db.createCollection('message');
    db.createCollection('server_message');
    db.createCollection('server_offline');
    db.createCollection('offline');
   
    db.getCollection('_sequeue').save({collection:'message',seq:0});
    db.getCollection('_sequeue').save({collection:'server_message',seq:0});
    db.getCollection('_sequeue').save({collection:'server_offline',seq:0});
    db.getCollection('_sequeue').save({collection:'offline',seq:0});
    
    db.system.js.insert(
    {_id:"getNextSequence",value:function getNextSequence (name) {
     var ret = db._sequeue.findAndModify({
          query: { collection: name },
          update: { $inc: { seq: NumberLong(1) } },
          new: true
      });
      return ret.seq.floatApprox;
     }
     });
  ```
  > 与用户管理相关的操作基本都要在 admin 数据库下运行，要先 `use admin`;如果在某个单一的数据库下，那只能对当前数据库的权限进行操作;`db.addUser`是老版本的操作，现在版本也还能继续使用，创建出来的 user 是带有 root role 的超级管理员。
   
