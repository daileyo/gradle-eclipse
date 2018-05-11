#!/bin/bash

ECLIPSE_TAR=eclipse-jee-oxygen-3a-linux-gtk-x86_64.tar.gz

mkdir -p /opt/eclipse/oxygen

wget --no-cookies http://mirror.csclub.uwaterloo.ca/eclipse/technology/epp/downloads/release/oxygen/3a/$ECLIPSE_TAR
tar -xzf $ECLIPSE_TAR && mv eclipse/* /opt/eclipse/oxygen

alternatives --install /usr/bin/eclipse eclipse /opt/eclipse/oxygen/eclipse 2
alternatives --set eclipse /opt/eclipse/oxygen/eclipse

rm -rf eclipse
