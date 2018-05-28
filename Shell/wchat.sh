#!/bin/bash
# FileName: wchat.sh
# Description: send message to wechat app
# Author: Lv Xiaoteng
# Email: youger.lv@gmail.com
# Date: Tue Oct 10 17:16:16 HKT 2017

PURL="http://XX"
function body() {
    local int AppID=XX
    local UserID="XX"
    local Msg=$(echo "$@" | cut -d" " -f3-)
    printf '{\n'
    printf '\t"appId": '"$AppID"",\n"
    printf '\t"list": [\n'
    printf '\t  {\n'
    printf '\t  "description": "'"$Msg"\"",\n"
    printf '\t  "title": "'"ZA告警"\""\n"
    printf '\t  }\n'
    printf '\t],\n'
    printf '\t"userList": [\n'
    printf '\t  '\""$UserID"\""\n"
    printf '\t]\n'
    printf '}\n'
}
/usr/bin/curl -X POST --header 'Content-Type: application/json' --data-ascii "$(body $1 $2 $3)" $PURL
