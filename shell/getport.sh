#!/bin/bash
# Description: get the port of tomcat
# Author: Lv Xiaoteng
# Date: 2017-09-23
# Email: yeah6066@gmail.com

CONNECTOR_PORT=$(grep "Connector port=" $1/conf/server.xml | grep HTTP/1.1 | awk '{print $2}' | awk -F = '{print $2}')
SHUTDOWN_PORT=$(grep "Server port=" $1/conf/server.xml | awk '{print $2}' | awk -F= '{print $2}')
AJP_PORT=$(grep "Connector port=" $1/conf/server.xml | grep AJP/1.3 | awk '{print $2}' | awk -F = '{print $2}')

echo "------------------------------"
echo "CONNECTOR_PORT=$CONNECTOR_PORT"
echo "------------------------------"
echo " "
echo "------------------------------"
echo "SHUTDOWN_PORT=$SHUTDOWN_PORT"
echo "------------------------------"
echo " "
echo "------------------------------"
echo "AJP_PORT=$AJP_PORT"
echo "------------------------------"

echo "Thank you for use!"
