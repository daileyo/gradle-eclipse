#!/bin/bash

GRADLE_HOME=/opt/gradle/$GRADLE_VERSION

mkdir -p /opt/gradle/$GRADLE_VERSION
GRADLE_ZIP=gradle-${GRADLE_VERSION}-all.zip
ARCHIVES=/opt/archives

cd $ARCHIVES 
echo "We are here:  ${PWD}"
printf "The following is in here\n****"
ls
echo "****"

if [ -e "${GRADLE_ZIP}" ]; then
    printf "    ${GRADLE_ZIP} exists\n"
else
    printf "   Downloading Gradle ${GRADLE_VERSION} as ${GRADLE_ZIP}\n" \
    && curl -O -L https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip -s
    echo "listing files"
    ls
fi

unzip -q $GRADLE_ZIP -d .
mv gradle-${GRADLE_VERSION}/* /opt/gradle/$GRADLE_VERSION

alternatives --install /usr/bin/gradle gradle /opt/gradle/$GRADLE_VERSION/bin/gradle 2
alternatives --set gradle /opt/gradle/$GRADLE_VERSION/bin/gradle

sed -i "1iexport GRADLE_HOME=${GRADLE_HOME}" /etc/bashrc
touch /scripts/gralde-put-me-here
touch /home/gradle/.gradle/gradle-put-me-here
 


