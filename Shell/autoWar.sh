#!/bin/bash
# Description: autodeploy tomcat
# Author: Lv Xiaoteng
# Date: 2017-06-29
# Email: <yeah6066@gmail.com>
# Notice: 此脚本适合于新部署项目到新的tomcat,全都是新的环境

echo ""
echo "===================开始自动部署==================="
echo ""

# 自定义相关变量
read -p "请输入您的 Tomcat-Connector 端口:" C_PORT
read -p "请输入您的 Tomcat-AJP 端口:" A_PORT
read -p "请输入您的 Tomcat-ShutDown 端口:" S_PORT
read -p "请把您的项目名称简写成3个或者4个字母:" PRO_NAME
NET_NAME=$(ls /sys/class/net | grep 'e')
IPADDR=$(ifconfig $NET_NAME | grep netmask | awk '{print $2}')
TomcatPath=/usr/local/tomcat-project/pro-$PRO_NAME-$C_PORT
sleep 1
echo "您的项目所在目录路径为 $TomcatPath"

# 下载并解压tomcat软件包
echo "正在准备Tomcat软件包,请稍等..."
rpm -q wget &> /dev/null  || yum -y install wget 
[ -d /opt/soft ] &> /dev/null || mkdir -p /opt/soft
[ -d /usr/local/tomcat-project ] &> /dev/null || mkdir -p /usr/local/tomcat-project

cd /opt/soft
[ -f /opt/soft/apache-tomcat-8.0.44.tar.gz ] &> /dev/null

if [ $? -eq 0 ] ; then
        tar zxf apache-tomcat-8.0.44.tar.gz -C /usr/local/tomcat-project
else
        wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-8/v8.0.44/bin/apache-tomcat-8.0.44.tar.gz && tar zxf apache-tomcat-8.0.44.tar.gz -C /usr/local/tomcat-project
fi

# 重命名tomcat文件夹，删除无用的文件
mv /usr/local/tomcat-project/apache-tomcat-8.0.44 $TomcatPath
cd $TomcatPath
rm -rf LICENSE NOTICE R*
sleep 1
echo "Tomcat软件及目录准备完成！"

# 修改tomcat配置文件
echo "正在配置相关端口,请稍等..."
sed -i "22s/"8005"/$S_PORT/g" $TomcatPath/conf/server.xml
sed -i "69s/"8080"/$C_PORT/g" $TomcatPath/conf/server.xml
sed -i "91s/"8009"/$A_PORT/g" $TomcatPath/conf/server.xml
sleep 1
echo "配置端口完成,现在开始部署项目吧,哈哈"
sleep 1
echo ""

echo "开始进行相关授权..."
echo ""
sleep 1
read -p "请问您用哪个SSH账号部署 $PRO_NAME 项目:" T_USER

# 倒计时功能
seconds_left=5
echo "好的,马上给你相关权限,请等待 ${seconds_left} 秒...."  
while [ $seconds_left -gt 0 ];do
echo -n $seconds_left  
sleep 1
seconds_left=$(($seconds_left - 1))
echo -ne "\r     \r"  
done

# 授权
chown -R $T_USER:$T_USER $TomcatPath
echo "您已经有权限了,马上开始自动化部署！"

# 停止Tomcat
cd $TomcatPath/bin
PID=$(ps -fu $T_USER | grep pro-$PRO_NAME-$C_PORT | grep -v grep | awk '{print $2}')

if [ -z "$PID" ];then
    echo "NO TOMCAT SERVER PROCESS!" && echo "现在可以上传war包了！"
else
    su - $T_USER $TomcatPath/bin/shutdown.sh
    # 倒计时
    seconds_left=15
    echo "正在停止Tomcat,请等待 ${seconds_left} 秒...."  
    while [ $seconds_left -gt 0 ];do
    echo -n $seconds_left  
    sleep 1
    seconds_left=$(($seconds_left - 1))
    echo -ne "\r     \r"  
    done
    
    # 判断tomcat是否已停止
    netstat -antpu | grep $C_PORT &> /dev/null
    if [ $? -eq 0 ] ; then
        echo "Tomcat还没停止，请继续等待...."
    else
        echo "Tomcat已经停止，开始上传war包到webapps目录下..."
    fi
fi

# 上传War包到webapps目录下
read -p "请输入您现在war包的位置:" WAR_PATH
read -p "请输入您现在war包的名称:" WAR_NAME

sleep 2
echo "开始上传war包,请稍等..."
cp -rf $WAR_PATH/$WAR_NAME.war $TomcatPath/webapps
sleep 1
echo "上传war包完成！"
echo ""
echo "正在启动tomcat,请稍等..."
su - $T_USER $TomcatPath/bin/startup.sh
echo ""
sleep 1
echo "tomcat日志请参考 tail -f $TomcatPath/logs/catalina.out"

sleep 15
echo "tomcat项目初步测试地址为 http://$IPADDR:$C_PORT/$WAR_NAME"

echo ""
echo "===================部署完成==================="
echo ""

