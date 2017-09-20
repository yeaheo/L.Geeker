## Kubernetes集群安装部署—验证

- 本部分主要用于验证前四部分集群安装是否完成，集群的可用性等

### 集群验证
- 主要验证方式是在Master上运行相关命令，看能否与nodes通信，具体如下：
- 命令：
  - `kubectl get all`
  - `kubectl get nodes`
- 命令输出结果如下：
  ``` bash
  [root@test-node7 opt]# kubectl get all
  NAME             CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
  svc/kubernetes   10.254.0.1   <none>        443/TCP   1d
  ```
  - 
  ``` bash
  [root@test-node7 opt]# kubectl get nodes
  NAME         STATUS    AGE       VERSION
  test-node6   Ready     15m       v1.7.6
  test-node7   Ready     23h       v1.7.6
  test-node8   Ready     13m       v1.7.6
  ```
  
- 如果输出信息如上所示，表示集群可用！
- 现在可以正常使用啦！！！

