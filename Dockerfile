FROM centos:latest

RUN yum install -y wget && yum install -y unzip

VOLUME [ "/scripts" ]
ADD scripts /scripts

#install java
RUN /scripts/install-java.sh
#install eclipse
RUN /scripts/install-eclipse.sh
#install gradle
RUN /scripts/install-gradle.sh
#install rcp

#set /etc/bashrc

#Locale info