## 基于CentOS的python安装MySQLdb和xlrd模块
- 当我们需要将execl表格导入到MySQL数据库中，我们可以用python代码实现，但是默认python并不会安装相应模块，需要我们自己安装
- 我们需要用到两个模块：xlrd和MySQLdb

### 安装xlrd模块
- 安装前
  ``` xml
  >>> import xlrd
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  ImportError: No module named xlrd
  >>> 
  ```
- 开始安装
  ``` bash
  yum -y install python-setuptools
  easy_install xlrd
  ```
- 安装后验证：
  ``` xml
  >>> import xlrd
  >>> 
  ```
- 表示xlrd模块安装完成！

### 安装MySQLdb模块
- 安装前
  ``` xml
  >>> import MySQLdb
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  ImportError: No module named xlrd
  >>> 
  ```
- 开始安装
  ``` bash
  yum -y install python-setuptools
  easy_install pip
  yum -y install python-devel
  pip install mysql-python
  ```
- 安装后验证：
  ``` xml
  >>> import MySQLdb
  >>> 
  ```
- 至此，xlrd和MySQLdb模块安装完成！
