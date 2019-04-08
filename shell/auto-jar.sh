#!/bin/bash
# Description: CI/CD script(jar)
# Date: 2018-06-25
# Author: Lv Xiaoteng
# Email: <helleo.cn@gmail.com>

# 定义相关环境变量
DATE=$(date +%Y%m%d)

PRO_NAME=project_name

PROHOME_DIR=/opt/prohome/$PRO_NAME

BACKUP_DIR=/opt/backup

CI_DIR=/srv/target

PRO_VERSION=1.0.0

# 创建 ProHome 及 项目备份目录
[ -d $BACKUP_DIR ] || mkdir -p $BACKUP_DIR

[ -d $CI_DIR ] || mkdir -p $CI_DIR

[ -d $PROHOME_DIR ] || mkdir -p $PROHOME_DIR

# 停止相关项目进程
ps aux | grep $PRO_NAME | grep -v grep | awk '{print $2}' | xargs kill -9

# 备份先前项目包
tar -zcPf $BACKUP_DIR\/$PRO_NAME-$DATE\.tar\.gz $PROHOME_DIR/*

# 删除之前的项目包
rm -rf $PROHOME_DIR/*

# 将新构建的包放到指定目录下
cp $CI_DIR\/$PRO_NAME\-$PRO_VERSION\.jar $PROHOME_DIR/

# 重启进程
nohup java -jar $PRO_NAME.jar &



