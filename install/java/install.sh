#!/bin/sh
root=$PWD
download=~/Downloads
prefix=/usr/local/cellar

rpm -qa|grep java
yum -y remove java

wget http://download.oracle.com/otn-pub/java/jdk/7u3-b04/jdk-7u3-linux-x64.rpm
mkdir /usr/java
rpm -ivh jdk-7u3-linux-x64.rpm  
echo "export JAVA_HOME=/usr/java/jdk1.7.0_03/" >> /etc/profile
echo "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile
