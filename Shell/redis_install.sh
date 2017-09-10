#!/bin/bash
# Description: Install Redis Server
# Date: 2017-08-15
# Author: Lv Xiaoteng
# Email: <yeah6066@gmail.com>

SOFT_DIR=/opt/soft
INSTALL_DIR=/usr/local
PREFIX_DIR=$INSTALL_DIR/redis401

read -p "请输入 redis 服务端口：" PORT
read -p "请输入 redis 服务的密码(尽量复杂)：" PASSWORD

echo -e "\033[41;33m 安装信息参见/tmp/redis_install.log \033[0m"
echo -e "\033[41;33m 可以使用 tail -f /tmp/redis_install.log 追踪安装日志 \033[0m"
echo ""
# 检查基本依赖包
echo -e "\033[47;30m 正在检查并安装所需依赖包... \033[0m"
rpm -q gcc make &> /tmp/redis_install.log || yum -y install gcc* make &> /tmp/redis_install.log
rpm -q wget &> /tmp/redis_install.log || yum -y install wget &> /tmp/redis_install.log
rpm -q tcl &> /tmp/redis_install.log || yum -y install tcl &> /tmp/redis_install.log
echo -e "\033[47;30m 依赖包安装完毕 \033[0m"

# 检查软件目录是否存在
[ -d $SOFT_DIR ] || mkdir -p /opt/soft &> /tmp/redis_install.log

# 下载redis相关软件
cd $SOFT_DIR &> /dev/null
echo -e "\033[47;30m 正在下载redis源码包,请稍等... \033[0m"
wget http://download.redis.io/releases/redis-4.0.1.tar.gz &> /tmp/redis_install.log
echo -e "\033[47;30m redis软件包下载完成！\033[0m"

# 解压源码包
tar xf redis-4.0.1.tar.gz -C $INSTALL_DIR &> /dev/null
mv $INSTALL_DIR/redis-4.0.1 $PREFIX_DIR &> /dev/null
cd $PREFIX_DIR &> /dev/null

echo -e "\033[47;30m 正在编译... \033[0m"
make &> /tmp/redis_install.log
echo -e "\033[47;30m 编译完成！进入make test模式倒计时... \033[0m"

seconds_left=5
while [ $seconds_left -gt 0 ];do
echo -n $seconds_left  
sleep 1
seconds_left=$(($seconds_left - 1))
echo -ne "\r     \r"  
done

echo -e "\033[47;30m 正在 make test \033[0m"
make test &> /tmp/redis_install.log && make install &> /tmp/redis_install.log
echo -e "\033[47;30m 检测并编译完成！\033[0m"

# 判断是否安装成功
if [ -f $PREFIX_DIR/src/redis-server ];then
    echo -e "\033[47;30m Redis安装成功！\033[0m"
else
    echo -e "\033[47;30m Redis没有安装成功，请重新安装！\033[0m" && exit 0
fi

# 路径优化
mkdir $PREFIX_DIR/{bin,log} &> /dev/null
cp $PREFIX_DIR/src/redis-cli $PREFIX_DIR/src/redis-server $PREFIX_DIR/bin &> /dev/null
ln -s $PREFIX_DIR/bin/* /usr/bin

# 修改相关配置文件
echo ""
#read -p "请输入 redis 服务端口：" PORT
#read -p "请输入 redis 服务的密码(尽量复杂)：" PASSWORD

sed -i "92s/"6379"/$PORT/g" $PREFIX_DIR/redis.conf
sed -i "136s/no/yes/g" $PREFIX_DIR/redis.conf
sed -i "171s/\"\"/\"\/usr\/local\/redis401\/log\/redis.log\"/g" $PREFIX_DIR/redis.conf
sed -i "500a\requirepass $PASSWORD" $PREFIX_DIR/redis.conf

# 输出结果
echo ""
echo -e "\033[47;30m Redis配置完成！\033[0m"
echo -e "\033[47;30m 现在可以启动redis服务了！\033[0m"
echo -e "\033[47;30m redis-server $PREFIX_DIR/redis.conf \033[0m"


# 


