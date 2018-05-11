#!/bin/bash

GRADLE_VERSION=2.13
GRADLE_ZIP=gradle-2.13-all.zip

mkdir -p /opt/gradle/$GRADLE_VERSION
GRADLE_HOME=/opt/gradle/$GRADLE_VERSION

wget -N https://services.gradle.org/distributions/$GRADLE_ZIP
unzip -q $GRADLE_ZIP -d .
mv gradle-${GRADLE_VERSION}/* /opt/gradle/$GRADLE_VERSION

alternatives --install /usr/bin/gradle gradle /opt/gradle/$GRADLE_VERSION/bin/gradle 2
alternatives --set gradle /opt/gradle/$GRADLE_VERSION/bin/gradle

sed -i "1iexport GRADLE_HOME=${GRADLE_HOME}" /etc/bashrc


