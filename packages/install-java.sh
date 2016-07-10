#!/bin/bash
JVM="jdk1.8.0_66"
yum -y localinstall jdk-8u66-linux-x64.rpm && \
	ln -sf /usr/java/${JVM} /usr/java/latest 
	
if [ $? -ne 0 ]; then
	cd /usr
	mkdir -p java
	cd java
	tar axvf /vagrant/packages/jdk-8u66-linux-x64.tar.gz
	ln -sf ${JVM} latest
fi

bins="java javac jar keytool"
for i in ${bins}; do
	alternatives --install /usr/bin/${i} ${i} /usr/java/latest/bin/${i} 0	
	alternatives --set ${i} /usr/java/latest/bin/${i}
done
