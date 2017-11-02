#!/bin/bash
# -------------------------------------------------------------------------------
# FileName:    zookeeper.sh
# Revision:    1.0
# Date:        2017/11/01
# Author:      Lv Xiaoteng
# Email:       yeah6066@gmail.com
# Description: the script to install zookeeper cluster
# Notes:       
# -------------------------------------------------------------------------------
# Copyright:   2017 (c) Lv Xiaoteng
# License:     GPL

# 定义相关变量
INSTALL_PATH=/usr/local/zookeeper-cluster

DATA_DIR_1=/data/zookeeper-cluster/zookeeper-node1/data
LOG_DIR_1=/data/zookeeper-cluster/zookeeper-node1/logs

DATA_DIR_2=/data/zookeeper-cluster/zookeeper-node2/data
LOG_DIR_2=/data/zookeeper-cluster/zookeeper-node2/logs

DATA_DIR_3=/data/zookeeper-cluster/zookeeper-node3/data
LOG_DIR_3=/data/zookeeper-cluster/zookeeper-node3/logs

SOFT_DIR=/opt/soft

#获取IP地址
IPADDR=$(ifconfig eth0 | grep netmask | awk '{print $2}')

#检查目录是否存在，并创建
[ -d $DATA_DIR_1 ] || mkdir -p $DATA_DIR_1
[ -d $LOG_DIR_1 ] || mkdir -p $LOG_DIR_1

[ -d $DATA_DIR_2 ] || mkdir -p $DATA_DIR_2
[ -d $LOG_DIR_2 ] || mkdir -p $LOG_DIR_2

[ -d $DATA_DIR_3 ] || mkdir -p $DATA_DIR_3
[ -d $LOG_DIR_3 ] || mkdir -p $LOG_DIR_3

[ -d $INSTALL_PATH ] || mkdir -p $INSTALL_PATH

[ -d $SOFT_DIR ] || mkdir -p $SOFT_DIR

# 下载安装包
cd $SOFT_DIR
rpm -qa wget || yum -y install wget &> /dev/null
echo "正在下载zookeeper安装包...详细信息如下："
wget http://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz
echo "zookeeper安装包下载完成！"

# 准备node1
echo "准备安装node1..."
tar zxf zookeeper-3.4.10.tar.gz -C /usr/src
cd /usr/src
mv ./zookeeper-3.4.10 $INSTALL_PATH/zookeeper-node1
cd $INSTALL_PATH
cd $INSTALL_PATH/zookeeper-node1/conf
cp zoo_sample.cfg zoo.cfg

echo " "
echo "正在准备node1配置文件..."
sed -i "12s/\/tmp\/zookeeper/\/data\/zookeeper-cluster\/zookeeper-node1\/data/g" zoo.cfg
echo "dataLogDir=/data/zookeeper-cluster/zookeeper-node1/logs" >> zoo.cfg
echo "server.1=$IPADDR:2887:3887" >> zoo.cfg
echo "server.2=$IPADDR:2888:3888" >> zoo.cfg
echo "server.3=$IPADDR:2889:3889" >> zoo.cfg
echo "1" > $DATA_DIR_1/myid
echo " "
echo "node1配置完成！"

#准备node2
echo ""
echo "准备安装node2..."
cd $INSTALL_PATH
cp -rf zookeeper-node1 zookeeper-node2

echo ""
echo "正在准备node2配置文件..."
cd zookeeper-node2/conf
sed -i "12s/1/2/g" zoo.cfg
sed -i "14s/2181/2182/g" zoo.cfg
sed -i "29s/1/2/g" zoo.cfg
echo "2" > $DATA_DIR_2/myid
echo " "
echo "node2配置完成！"

#准备node3
echo " "
echo "准备安装node3"
cd $INSTALL_PATH
cp -rf zookeeper-node1 zookeeper-node3

echo ""
echo "正在准备node3配置文件...."
cd zookeeper-node3/conf
sed -i "12s/1/3/g" zoo.cfg
sed -i "14s/2181/2183/g" zoo.cfg
sed -i "29s/1/3/g" zoo.cfg
echo "3" > $DATA_DIR_3/myid
echo " "
echo "node3配置完成！"

# 启动集群服务
echo " "
echo "正在启动集群服务..."
for i in $(seq 3);
do
cd /usr/local/zookeeper-cluster/zookeeper-node$i/bin
./zkServer.sh start
sleep 2
./zkServer.sh status
if [ $? -eq 0 ];then
echo " "
echo "zookeeper集群--node$i--启动完成！"
echo " "
else
echo " "
echo "zookeeper集群--node$i--启动失败！请检查！！！"
echo " "
fi
done




