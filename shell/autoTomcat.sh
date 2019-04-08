#!/bin/bash
# Description: autodeploy tomcat
# Author: Lv Xiaoteng
# Date: 2017-06-29
# Email: <yeah6066@gmail.com>
# Notice: 此脚本适用于创建一个新的Tomcat不用部署项目到webapps里

echo ""
echo "===================开始自动部署==================="
echo ""

# 自定义相关变量
read -p "请输入您的 Tomcat-Connector 端口:" C_PORT
read -p "请输入您的 Tomcat-AJP 端口:" A_PORT
read -p "请输入您的 Tomcat-ShutDown 端口:" S_PORT
read -p "请把您的项目名称简写成3个或者4个字母:" PRO_NAME
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

seconds_left=5
echo "好的,马上给你相关权限,请等待 ${seconds_left} 秒...."  
while [ $seconds_left -gt 0 ];do
echo -n $seconds_left  
sleep 1
seconds_left=$(($seconds_left - 1))
echo -ne "\r     \r"  
done

chown -R $T_USER:$T_USER $TomcatPath
sleep 1
echo "您已经有权限了,现在可以自己部署或者联系管理员进行项目部署！"

