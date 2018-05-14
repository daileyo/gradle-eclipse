#!/bin/bash
typeset -A JDK_LIST
ECLIPSE_TAR=eclipse-jee-oxygen-3a-linux-gtk-x86_64.tar.gz
ECLIPSE_LIST=(
    [oxygen]="http://mirror.csclub.uwaterloo.ca/eclipse/technology/epp/downloads/release/oxygen/3a/eclipse-jee-oxygen-3a-linux-gtk-x86_64.tar.gz"
    [neon]="http://mirror.csclub.uwaterloo.ca/eclipse/technology/epp/downloads/release/neon/3/eclipse-jee-neon-3-linux-gtk-x86_64.tar.gz"
    [mars]="http://mirror.csclub.uwaterloo.ca/eclipse/technology/epp/downloads/release/mars/2/eclipse-jee-mars-2-linux-gtk-x86_64.tar.gz"
)

mkdir -p /opt/eclipse/oxygen

printf "   Downloading Oxygen\n" && curl -L http://mirror.csclub.uwaterloo.ca/eclipse/technology/epp/downloads/release/oxygen/3a/$ECLIPSE_TAR --output $ECLIPSE_TAR -s
tar -xzf $ECLIPSE_TAR && mv eclipse/* /opt/eclipse/oxygen

alternatives --install /usr/bin/eclipse eclipse /opt/eclipse/oxygen/eclipse 2
alternatives --set eclipse /opt/eclipse/oxygen/eclipse

rm -rf eclipse
