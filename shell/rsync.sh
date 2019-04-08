#!/bin/bash
# Description: Rsync file
# Author: Lv Xiaoteng
# Email: <yeah6066@gmail.com>
# Date: 2017-08-14

# 添加需要过滤的文件
EXCLUDE_FILE="/opt/file/exclude"
# 设定相关变量
SOURCE_DIR=/opt/backup/tar
DEST_DIR=/opt/soft
REMOTE_IP=6.6.6.12

# 开始同步
/usr/bin/rsync -e "ssh -p22" -avpgolr --exclude-from $EXCLUDE_FILE $SOURCE_DIR $REMOTE_IP:$DEST_DIR



