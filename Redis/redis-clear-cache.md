## Redis-清理缓存
- 有时候我们需要清理一下 redis 里缓存的数据，此时我们需要安装 redis 客户端连接 redis 服务器,一般 redis 的客户端在安装redis 的时候就安装好了

- **清理缓存**

- 清理当前所在数据库缓存
  ``` bash
  > flashdb
  ```
  
- 清理 redis 全部缓存
  ``` bash
  > flashall
  ```

- 清理指定 `key` 值
  ``` bash
  > key *    # 查看所有key
  > del key <指定 key 值>
  ```
