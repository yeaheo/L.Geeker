## FastDFS安装脚本
```bash
#!/bin/bash
# Description: the script to install fastdfs
# Date: 2017-07-24
# Author: Lv Xiaoteng
# Email: <yeah6066@gmail.com>

# download libfastcommon source package from github and install it
# the github address: <https://github.com/happyfish100/libfastcommon.git>

# 定义相关变量
SOFT_PATH=/opt/soft
DATA_PATH=/data/fastdfs
STORE_PATH=/data/fastdfs/storage
INSTALL_PATH=/usr/local
CON_PATH=/etc/fdfs
NET_NAME=$(ls /sys/class/net | grep 'e')
IPADDR=$(ifconfig $NET_NAME | grep netmask | awk '{print $2}')
#IPADDR=$(ifconfig $NET_NAME | grep Mask | awk '{print $2}' | awk -F: '{print $2}')
# 判断目录是否存在
[ -d $SOFT_PATH ] || mkdir -p $SOFT_PATH &> /dev/null
[ -d $DATA_PATH ] || mkdir -p $DATA_PATH &> /dev/null
[ -d $STORE_PATH ] || mkdir -p $STORE_PATH &> /dev/null

# Git检测
cd $SOFT_PATH &> /dev/null
echo "正在检查 Git 软件包..."
rpm -q git &> /dev/null || yum -y install git &> /dev/null
echo "Git 软件安装成功！"

# 下载libfastcommon源码
echo "正在下载 libfastcommon 源码包"
git clone https://github.com/happyfish100/libfastcommon.git &> /dev/null

# 判断libfastcommon源码是否下载成功
if [ -d $SOFT_PATH/libfastcommon ];then
echo "libfastcommon download successful,continue!"
else
echo "libfastcommon download faild!"
fi

# 将其移动到/usr/local/目录下
mv $SOFT_PATH/libfastcommon $INSTALL_PATH
cd $INSTALL_PATH/libfastcommon

# 编译环境检测
echo "正在检查编译环境..."
rpm -q gcc &> /dev/null || yum -y install gcc* make &> /dev/null
echo "编译环境符合要求"

echo "正在安装 libfastcommon...."
./make.sh  &> /dev/null && ./make.sh install &> /dev/null
echo "libfastcommon install successful!!!"

# download FastDFS source package and unpack it
cd $INSTALL_PATH &> /dev/null
echo "正在下载 FastDFS 源码...."
git clone https://github.com/happyfish100/fastdfs &> /dev/null
echo "FastDFS 源码下载完成！"

# enter the FastDFS dir
cd $INSTALL_PATH/fastdfs

# execute and install
echo "正在安装FastDFS,请稍等...."
./make.sh &> /dev/null && ./make.sh install &> /dev/null
sleep 2

if [ -d $CON_PATH ];then
echo "FastDFS install successful,continue!"
else
echo "FastDFS install faild!"
fi

# edit/modify the config file of tracker 
cp $CON_PATH/tracker.conf.sample $CON_PATH/tracker.conf &> /dev/null
echo "正在修改 tracker 的配置文件"
sed -i '22s/\/home\/yuqing\/fastdfs/\/data\/fastdfs/g' $CON_PATH/tracker.conf &> /dev/null
sed -i '260s/8080/80/g' $CON_PATH/tracker.conf &> /dev/null
echo "配置文件修改成功！"

# run server programs
ln -s /usr/bin/fdfs_trackerd /usr/local/bin &> /dev/null
ln -s /usr/bin/stop.sh /usr/local/bin &> /dev/null
ln -s /usr/bin/restart.sh /usr/local/bin &> /dev/null

# run the fdfs_trackerd service
echo "准备启动 fdfs_trackerd 服务...."
service fdfs_trackerd start &> /dev/null

sleep 8

# make sure the fdfs_trackerd service
netstat -antpu | grep 22122 &> /dev/null
if [ $? -eq 0 ];then
echo "fdfs_trackerd running...."
else
echo "fdfs_trackerd run faild!"
fi

# edit/modify the config file of storage
cp $CON_PATH/storage.conf.sample $CON_PATH/storage.conf &> /dev/null
echo "正在修改 storage 的配置文件"
sed -i '41s/\/home\/yuqing\/fastdfs/\/data\/fastdfs\/storage/g' $CON_PATH/storage.conf &> /dev/null
sed -i '109s/\/home\/yuqing\/fastdfs/\/data\/fastdfs\/storage/g' $CON_PATH/storage.conf &> /dev/null
sed -i "118s/192\.168\.209\.121/$IPADDR/g" $CON_PATH/storage.conf &> /dev/null
echo "配置文件修改成功！"

# run server programs
ln -s /usr/bin/fdfs_storaged /usr/local/bin &> /dev/null

# run the fdfs_trackerd service
echo "准备启动 fdfs_storaged 服务...."
service fdfs_storaged start &> /dev/null

sleep 5

# make sure the fdfs_storaged service
netstat -antpu | grep 23000 &> /dev/null
if [ $? -eq 0 ];then
echo "fdfs_storaged running...."
else
echo "fdfs_storaged run faild!"
fi
```
