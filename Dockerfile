FROM busybox:latest as archives

    ENV GRADLE_VERSION=2.13 \
        JAVA_VERSION=jdk8

    RUN wget -q https://rpmfind.net/linux/fedora/linux/releases/28/Everything/x86_64/os/Packages/u/unzip-6.0-38.fc28.x86_64.rpm \
        && rpm -i unzip-6.0-38.fc28.x86_64.rpm 

    RUN mkdir -p archives/gradle archives/java/$JAVA_VERSION \
        && wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip \
        && unzip -q gradle-${GRADLE_VERSION}-all.zip -d /archives/gradle
    
    RUN JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz" \
        && SECURITY_COOKIE="Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
        && JDK_TAR=$JAVA_VERSION.tar.gz \
        && wget -q --header "${SECURITY_COOKIE}" "${JDK_URL}" -O "${JDK_TAR}" \
        && mkdir -p /archives/java/${JAVA_VERSION} \
        && tar xzf $JDK_TAR -C /archives/java/${JAVA_VERSION} --strip-components 1

FROM oraclelinux:7-slim

    ENV GRADLE_VERSION=2.13 \
        JAVA_VERSION=jdk8

    ENV GRADLE_HOME="/opt/gradle/gradle-${GRADLE_VERSION}"  \
        GRADLE_OPTS=-Xmx4g \
        JAVA_DEFAULT_OPTS=-Xmx4g \
        JAVA_HOME="/opt/java/${JAVA_VERSION}" \
        JRE_HOME="/opt/java/${JAVA_VERSION}/jre" \
        LANG=en_US.utf8

    COPY --from=archives /archives /opt

    RUN update-alternatives --install /usr/bin/java java /opt/java/$JAVA_VERSION/bin/java 2 \
        && update-alternatives --install /usr/bin/jar jar /opt/java/$JAVA_VERSION/bin/jar 2 \
        && update-alternatives --install /usr/bin/javac javac /opt/java/$JAVA_VERSION/bin/javac 2 \
        && update-alternatives --install /usr/bin/gradle gradle $GRADLE_HOME/bin/gradle 2 \
        && update-alternatives --set java /opt/java/$JAVA_VERSION/bin/java \
        && update-alternatives --set jar /opt/java/$JAVA_VERSION/bin/jar \
        && update-alternatives --set javac /opt/java/$JAVA_VERSION/bin/javac \
        && update-alternatives --set gradle $GRADLE_HOME/bin/gradle \
        && sed -i "1iexport GRADLE_HOME=${GRADLE_HOME}/bin" /etc/bashrc \
        && sed -i "1iexport JAVA_HOME=${JAVA_HOME}" /etc/bashrc \
        && sed -i "1iexport JRE_HOME=${JRE_HOME}" /etc/bashrc \
        && groupadd -g 1000 gradle \
        && useradd -g gradle -u 1000 -s /bin/bash gradle \
        && mkdir /home/gradle/.gradle \
        && chown -R gradle:gradle /home/gradle \ 
        && ln -s /home/gradle/.gradle /root/.gradle \
        && touch /home/gradle/.gradle/gradle.properties && echo org.gradle.daemon=true >> /home/gradle/.gradle/gradle.properties
    
    USER gradle
    RUN printf "Testing configuration\n------------------------------------------------------------\n" \
        && alternatives --list \
        && printf "\n------------------------------------------------------------\n" \
        && head -3 /etc/bashrc \
        && printf "\n------------------------------------------------------------\n" \
        && gradle --version