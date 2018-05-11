#!/bin/bash

JAVA_VERSION=jdk1.8.0_171

mkdir -p /opt/java
#https://tecadmin.net/install-java-8-on-centos-rhel-and-fedora/

wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz"
tar xzf jdk-8u171-linux-x64.tar.gz -C /opt/java
cd /opt/java/$JAVA_VERSION

JAVA_HOME=/opt/java/$JAVA_VERSION
JRE_HOME=$JAVA_HOME/jre

alternatives --install /usr/bin/java java /opt/java/$JAVA_VERSION/bin/java 2
alternatives --install /usr/bin/jar jar /opt/java/$JAVA_VERSION/bin/jar 2
alternatives --install /usr/bin/javac javac /opt/java/$JAVA_VERSION/bin/javac 2
alternatives --set java /opt/java/$JAVA_VERSION/bin/java
alternatives --set jar /opt/java/$JAVA_VERSION/bin/jar
alternatives --set javac /opt/java/$JAVA_VERSION/bin/javac

sed -i "1iexport JAVA_HOME=${JAVA_HOME}" /etc/bashrc
sed -i "1iexport JRE_HOME=${JRE_HOME}" /etc/bashrc
