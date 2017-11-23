## Redis-清理缓存
- 有时候我们需要清理一下redis里缓存的数据，此时我们需要安装redis客户端连接redis服务器,一般redis的客户端在安装redis的时候就安装好了

- **清理缓存**
- 清理当前所在数据库缓存
- `> flashdb`
- 清理redis全部缓存
- `> flashall`
- 清理指定key值
- `> key *`  查看所有key
- `> del key +指定key值`

