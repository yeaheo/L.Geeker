#!/bin/bash
# Description: CI/CD script
# Date: 2018-06-07
# Author: Lv Xiaoteng
# Email: <helleo.cn@gmail.com>

# 定义相关环境变量
DATE=$(date +%Y%m%d)

PROHOME_DIR=/opt/prohome/cipro-8090

PRO_NAME=holiday

BACKUP_DIR=/opt/backup

CI_DIR=/srv/target

PRO_USER=citest

PRO_VERSION=1.0.0

# 创建 ProHome 及 项目备份目录
#[ -d $BACKUP_DIR ] || mkdir -p $BACKUP_DIR

#[ -d $CI_DIR ] || mkdir -p $CI_DIR

# 停止相关项目进程
ps aux | grep $PROHOME_DIR | grep -v grep | awk '{print $2}' | xargs kill -9

# 清理缓存
rm -rf $PROHOME_DIR/work/Catalina/localhost/* 

# 备份先前项目包
tar -zcPf $BACKUP_DIR\/$PRO_NAME-$DATE\.tar\.gz $PROHOME_DIR\/webapps\/$PRO_NAME\/

# 删除之前的项目包
rm -rf $PROHOME_DIR\/webapps\/*

# 将新构建的包放到指定目录下
cp $CI_DIR\/$PRO_NAME\-$PRO_VERSION\.war $PROHOME_DIR\/webapps\/$PRO_NAME\.war

# 改变项目属主及属组
#chown -R $PRO_USER\.$PRO_USER $PROHOME_DIR/

# 重启项目
$PROHOME_DIR/bin/startup.sh &> /dev/null

# 查看日志
#tail -f $PROHOME_DIR/logs/catalina.out

