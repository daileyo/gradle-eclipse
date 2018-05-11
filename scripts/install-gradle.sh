#!/bin/bash

GRADLE_VERSION=2.13
GRADLE_LIST="2.10 2.13 3.4.1 4.7"


GRADLE_HOME=/opt/gradle/$GRADLE_VERSION

i=3
for ver in $GRADLE_LIST; do 
    mkdir -p /opt/gradle/$ver
    GRADLE_ZIP=gradle-${ver}-all.zip
    curl -L https://services.gradle.org/distributions/$GRADLE_ZIP --output $GRADLE_ZIP -#
    unzip -q $GRADLE_ZIP -d .
    mv gradle-${ver}/* /opt/gradle/$ver

    alternatives --install /usr/bin/gradle gradle /opt/gradle/$ver/bin/gradle $i
    i=$((i+1))
    if [ "$GRADLE_VERSION" == "$ver" ]; then
        alternatives --set gradle /opt/gradle/$ver/bin/gradle
    fi
    rm -f $GRADLE_ZIP
    rm -rf ${GRADLE_ZIP%-all*}
done

sed -i "1iexport GRADLE_HOME=${GRADLE_HOME}" /etc/bashrc


