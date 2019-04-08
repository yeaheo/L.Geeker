## 基于 CentOS 的 python 安装 MySQLdb 和 xlrd 模块
- 当我们需要将 execl 表格导入到 MySQL 数据库中，我们可以用 python 代码实现，但是默认 python 并不会安装相应模块，需要我们自己安装
- 我们需要用到两个模块： xlrd 和 MySQLdb

### 安装 xlrd 模块
- 安装前
  
  ```py
  >>> import xlrd
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  ImportError: No module named xlrd
  >>> 
  ```
- 开始安装
  
  ```bash
  yum -y install python-setuptools
  easy_install xlrd
  ```
- 安装后验证：
  
  ```py
  >>> import xlrd
  >>> 
  ```
- 表示xlrd模块安装完成！

### 安装MySQLdb模块
- 安装前
  
  ```py
  >>> import MySQLdb
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  ImportError: No module named xlrd
  >>> 
  ```
- 开始安装
  
  ```bash
  yum -y install python-setuptools
  easy_install pip
  yum -y install python-devel
  pip install mysql-python
  ```
- 安装后验证：
  
  ```py
  >>> import MySQLdb
  >>> 
  ```
- 至此，xlrd 和 MySQLdb 模块安装完成！
