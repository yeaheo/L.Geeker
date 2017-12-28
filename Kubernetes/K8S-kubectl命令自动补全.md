## kubectl命令自动补全
- kubectl这个命令行工具非常重要，与之相关的命令也很多，我们也记不住那么多的命令，而且也会经常写错，所以命令自动补全是非常有必要的，kubectl命令行工具本身就支持complication，只需要简单的设置下就可以了。
- 以下是linux系统的设置命令：

  ``` bash
  source <(kubectl completion bash)
  echo "source <(kubectl completion bash)" >> ~/.bashrc
  ```
- 然后就可以自动补全了。
- 如果是普通用户上述命令依旧可用，复制执行即可！
- 如果发现不能自动补全，可以尝试安装 `bash-completion` 然后刷新即可！
