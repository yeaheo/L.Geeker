#!/bin/bash
# Description: Rsync file
# Author: Lv Xiaoteng
# Email: <yeah6066@gmail.com>
# Date: 2017-08-14
# Version: 1.0

# 添加需要过滤的文件
EXCLUDE_FILE="/opt/file/exclude"
# 设定相关变量
SOURCE_DIR=/opt/backup/tar
DEST_DIR=/opt/soft
REMOTE_IP=6.6.6.12
USER=root

#password file must not be other-accessible.
PASS_FILE=/root/rsync.pass

# if the DEST_DIR not found,then create one
[ ! -d $DEST_DIR ] && mkdir $DEST_DIR
[ ! -d $PASS_FILE ] && exit 2

# 开始同步
#/usr/bin/rsync -e "ssh -p22" -avpgolr --exclude-from $EXCLUDE_FILE $SOURCE_DIR $REMOTE_IP:$DEST_DIR
/usr/bin/rsync -azpgolr --delete --password-file=$PASS_FILE ${USER}@${REMOTE_IP}::$SOURCE_DIR $DEST_DIR/$(date +%Y%m%d)



