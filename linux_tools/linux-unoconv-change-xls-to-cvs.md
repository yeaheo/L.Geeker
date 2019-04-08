## unoconv 实现 xls 转 cvs 格式
- 安装 unoconv
  
  ```bash
  yum -y install unoconv
  ```

- unoconv 实现 xls 格式转 csv
  
  ```bash
  unoconv -f csv test.xls
  ```

  > `-f `后加要转换的格式，其后紧接原文件

- unoconv 实现 doc 格式转 pdf
  
  ```bash
  unoconv -f pdf test.doc
  ```
  
  > `-f`后加要转换的格式，其后紧接原文件

- 注意：
- 在转换格式的时候偶尔会报如下错误：
  
  ```bash
  /usr/lib64/libreoffice/program/soffice.bin X11 error: Can't open display:
  Set DISPLAY environment variable, use -display option
  or check permissions of your X-Server
  (See "man X" resp. "man xhost" for details)
  ```
- 解决办法：
  
  ```bash
  yum install libreoffice-headless
  ```

### 其他转化格式的工具
- The drawback of the above method of converting xlsx files using Gnumeric is that you need to install Gnumeric which may be too bloated software to install just for file conversion. A more lightweight way is to use xlsx2csv which is a python tool for xlsx to csv conversion
- 具体使用方法
  
  ```bash
  git clone https://github.com/dilshod/xlsx2csv.git
  cd xlsx2csv
  ./xlsx2csv.py input.xlsx output.csv
  ```
  
  
