#!/bin/bash
typeset -A JDK_LIST
JAVA_VERSION=jdk1.8
JDK_LIST=(
    [jdk7]="https://sourceforge.net/projects/jdk7src/files/latest/download"
    [jdk8]="http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz"
    [jdk10]="http://download.oracle.com/otn-pub/java/jdk/10.0.1+10/fb4372174a714e6b8c52526dc134031e/jdk-10.0.1_linux-x64_bin.tar.gz"
)


SECURITY_COOKIE="Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"

JAVA_HOME=/opt/java/$JAVA_VERSION
JRE_HOME=$JAVA_HOME/jre

i=3
#download all files (parallel)
for jdk in "${!JDK_LIST[@]}"; do
    mkdir -p /opt/java/${jdk}
    JDK_TAR=$jdk.tar.gz

    printf "Downloading ${jdk}.\n" && curl -L --header "${SECURITY_COOKIE}" "${JDK_LIST[$jdk]}" --output "${JDK_TAR}" -s &
done
wait
printf "jdk downloads done.\n"
#extract all files (parallel)
for jdk in "${!JDK_LIST[@]}"; do
    JDK_TAR="${jdk}.tar.gz"
    printf "Extracting ${JDK_TAR}.\n" && tar xzf $JDK_TAR -C .
done
wait
printf "jdk extractions complete.\n"
#configure default and cleanup

for jdk in "${!JDK_LIST[@]}"; do
    JDK_TAR="${jdk}.tar.gz"
    alternatives --install /usr/bin/java java /opt/java/$JAVA_VERSION/bin/java $i
    alternatives --install /usr/bin/jar jar /opt/java/$JAVA_VERSION/bin/jar $i
    alternatives --install /usr/bin/javac javac /opt/java/$JAVA_VERSION/bin/javac $i
    i=$((i+1))
    if [ "$JAVA_VERSION" == "$jdk" ]; then
        alternatives --set java /opt/java/$jdk/bin/java
        alternatives --set jar /opt/java/$jdk/bin/jar
        alternatives --set javac /opt/java/$jdk/bin/javac
    fi
    mv $JDK_TAR/* /opt/java/$jdk
    rm -f $JDK_TAR
    rm -rf ${JDK_TAR%.tar*}
done

sed -i "1iexport JAVA_HOME=${JAVA_HOME}" /etc/bashrc
sed -i "1iexport JRE_HOME=${JRE_HOME}" /etc/bashrc
