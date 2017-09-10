#!/bin/bash
# Description: autodeploy tomcat
# Author: Lv Xiaoteng
# Date: 2017-06-29
# Email: <yeah6066@gmail.com>

echo "################开始自动部署################"

# 自定义相关变量
PATH=`pwd`
DATE=`date +%Y%m%d`
read -p "Please input the port of your project:" PORT
read -p "Please input the name of your project:" PRO_NAME
read -p "Please input the name of your package:" WAR_NAME
BACKUP_PATH=/opt/backup
WAR_PATH=/opt/warFile
TomcatPath=/usr/local/tomcat-project/pro-$PRO_NAME-$PORT
sleep 1
echo "您的项目所在目录路径为 $TomcatPath"

# 停止Tomcat
cd $TomcatPath/bin
PID=$(ps -fu `whoami` | grep tomcat | grep -v grep | awk '{print $2}')
if [ -z "$PID" ];then
    echo "NO TOMCAT SERVER PROCESS!"
else
    $TomcatPath/bin/shutdown.sh
fi

sleep 15

# 做相关备份并删除旧的war包
echo "正在备份相关数据，请稍等..."
cd $TomcatPath/webapps && tar zcf $BACKUP_PATH/$WAR_NAME-$DATE ./$WAR_NAME
rm -rf $WAR_NAME && rm -rf $WAR_NAME.war
echo "备份完成！"

# 上传新的war包
echo "正在上传新的war包，请稍等..."
cp -rf $WAR_PATH/$WAR_NAME.war $TomcatPath/webapps
echo "上传完成！"

# 重启TOMCAT服务
echo "正在启动tomcat..."
cd $TomcatPath/bin
./startup.sh
echo "命令已经运行了，等着吧！"

sleep 3

echo "################部署结束################"


