#!/bin/bash
# Description: the scripts install mysql
# Date: 2017-06-27
# Auth: Lv Xiaoteng
# Email: yeah6066@gmail.com

# query the mysql rpm
rpm -q mysql-server &> /dev/null && rpm -e mysql-server --nodeps
rpm -q mysql &> /dev/null && rpm -e mysql --nodeps
rpm -q ncurses-devel &> /dev/null || yum -y install ncurses-devel
rpm -q gcc &> /dev/null || yum -y install gcc*
rpm -q zlib-devel &> /dev/null || yum -y install zlib-devel
rpm -q pcre-devel &> /dev/null || yum -y install pcre-devel
rpm -q openssh-clients &> /dev/null || yum -y install openssh-clients

# download the cmake and mysql soft
rpm -q wget &> /dev/null || yum -y install wget
rpm -q git &> /dev/null || yum -y install git
cd /opt/soft
wget https://cmake.org/files/v3.8/cmake-3.8.2.tar.gz
wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.18.tar.gz
wget https://jaist.dl.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz

# install boost
tar zxf /opt/soft/boost_1_59_0.tar.gz -C /usr/src

# install cmake
tar zxf /opt/soft/cmake-*.tar.gz -C /usr/src
cd /usr/src/cmake-*

echo -e "\033[33m 正在配置cmake... \033[0m"
./configure &> /dev/null
echo -e "\033[33m 配置完成！ \033[0m"
echo -e "\033[33m 正在编译cmake... \033[0m"
gmake &> /dev/null
echo -e "\033[33m 编译完成！ \033[0m"
echo -e "\033[33m 正在安装cmake... \033[0m"
gmake install &> /dev/null

# determine whether the installation is successful
which cmake &> /dev/null
if [ $? -eq 0 ] ; then
        echo -e "\033[32m cmake insalled! \033[0m"
else 
        echo -e "\033[32m cmake not installed please install cmake! \033[0m"
exit 1
fi

# install mysql
useradd -M -s /sbin/nologin  mysql
tar zxf /opt/soft/mysql-*.tar.gz -C /usr/src/
cd /usr/src/mysql-*/
echo -e "\033[33m 正在配置Mysql... \033[0m"
cmake  -DCMAKE_INSTALL_PREFIX=/usr/local/mysql   -DSYSCONFDIR=/etc  -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci  -DWITH_EXTRA_CHARSETS=all -DWITH_BOOST=/usr/src/boost_1_59_0/ &> /dev/null
echo -e "\033[33m 配置完成！ \033[0m"
echo -e "\033[33m 正在编译Mysql... \033[0m"
make &> /dev/null
echo -e "\033[33m 编译完成！ \033[0m"
echo -e "\033[33m 正在安装Mysql... \033[0m"
make install &> /dev/null
[ -d /usr/local/mysql/bin ] &> /dev/null
if [ $? -eq 0 ] ; then
        echo  -e "\033[32m Mysql insalled! \033[0m"
else
        echo  -e "\033[32m Mysql not installed please install Mysql!\033[0m"
exit 1
fi

#chown -R mysql:mysql /usr/local/mysql
#/bin/cp -f  support-files/my-medium.cnf /etc/my.cnf
#/usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql  --datadir=/usr/local/mysql/data &> /dev/null
#/bin/ln -s /usr/local/mysql/bin/* /usr/bin
#/bin/cp -f  support-files/mysql.server   /etc/init.d/mysqld
#chmod +x /etc/init.d/mysqld 
#chkconfig --add mysqld
#service mysqld start
