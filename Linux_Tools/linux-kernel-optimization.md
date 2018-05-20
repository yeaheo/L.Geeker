## Linux 服务器内核参数优化
- 注意：
  
  > 本优化适合 Apache、 Nginx、 Squid 等多种 Web 应用，特殊的业务可能需要略作调整
  ```bash
  net.ipv4.tcp_max_orphans = 16384
  net.ipv4.tcp_max_syn_backlog = 16384
  net.ipv4.tcp_max_tw_buckets = 36000
  net.ipv4.tcp_timestamps = 0
  net.ipv4.tcp_synack_retries = 1
  net.ipv4.tcp_syn_retries = 1
  net.ipv4.tcp_tw_recycle = 1
  net.ipv4.tcp_tw_reuse = 1
  net.ipv4.tcp_syncookies = 1
  net.ipv4.tcp_mem = 94500000 915000000 927000000
  net.ipv4.tcp_fin_timeout = 2
  net.ipv4.tcp_keepalive_time = 600
  net.ipv4.ip_local_port_range = 4000   65000
  net.core.netdev_max_backlog = 16384
  net.core.somaxconn = 16384
  net.ipv4.route.gc_timeout = 100
  ```

- 其他场合：
  ```bash
  net.ipv4.ip_forward = 0   #路由转发功能需要的时候可以设置为1
  net.ipv4.conf.default.rp_filter = 1
  net.ipv4.conf.default.accept_source_route = 0
  kernel.sysrq = 0
  kernel.core_uses_pid = 1
  net.ipv4.tcp_syncookies = 1
  kernel.msgmnb = 65536
  kernel.msgmax = 65536
  kernel.shmmax = 68719476736
  kernel.shmall = 4294967296
  net.ipv4.tcp_max_tw_buckets = 6000
  net.ipv4.tcp_sack = 1
  net.ipv4.tcp_window_scaling = 1
  net.ipv4.tcp_rmem = 4096        87380   4194304
  net.ipv4.tcp_wmem = 4096        16384   4194304
  net.core.wmem_default = 8388608
  net.core.rmem_default = 8388608
  net.core.rmem_max = 16777216
  net.core.wmem_max = 16777216
  net.core.netdev_max_backlog = 262144
  net.core.somaxconn = 262144
  net.ipv4.tcp_max_orphans = 3276800
  net.ipv4.tcp_max_syn_backlog = 262144
  net.ipv4.tcp_timestamps = 0 
  net.ipv4.tcp_synack_retries = 1
  net.ipv4.tcp_syn_retries = 1
  net.ipv4.tcp_tw_recycle = 1
  net.ipv4.tcp_tw_reuse = 1
  net.ipv4.tcp_mem = 94500000 915000000 927000000
  net.ipv4.tcp_fin_timeout = 1
  net.ipv4.tcp_keepalive_time = 30
  net.ipv4.ip_local_port_range = 1024   65000
  ```
