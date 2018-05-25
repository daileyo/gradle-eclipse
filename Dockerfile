FROM centos:latest

RUN  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && yum install -y -q -e 0 unzip && yum install -y -q -e 0 git

VOLUME [ "/scripts" ]
ADD scripts /scripts

#install java
RUN /scripts/install-java.sh
#install eclipse
#RUN /scripts/install-eclipse.sh
#install gradle
RUN /scripts/install-gradle.sh
#install rcp

#set /etc/bashrc

#Locale info