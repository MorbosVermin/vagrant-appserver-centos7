#!/usr/bin/env bash
PUPPET_BASECONFIG=/vagrant/puppet/modules/baseconfig/files
PUPPET_PACKAGES=/vagrant/packages

echo
echo ">> Installing prerequisite packages and configurations, please wait..."
echo
mkdir -p /home/vagrant/bin
echo "Defaults:root !requiretty" >> /etc/sudoers.d/root
yum -q -y install mariadb mariadb-server httpd-devel mod_ssl tomcat tomcat-webapps tomcat-admin-webapps
CONFIG_FILES="etc/motd etc/httpd/conf.d/z-site.conf etc/my.cnf home/vagrant/bin/deploy home/vagrant/.bashrc etc/tomcat/server.xml etc/tomcat/tomcat-users.xml"
for file in ${CONFIG_FILES}; do
	cp -f ${PUPPET_BASECONFIG}/${file} /${file}
done

chown vagrant:vagrant /home/vagrant/ -R
chmod 0750 /home/vagrant/bin/deploy

echo
echo ">> Installing Oracle JDK v1.8.0u66, please wait..."
cd /usr
mkdir -p java
cd java
tar axf ${PUPPET_PACKAGES}/jdk-8u66-linux-x64.tar.gz
ln -s jdk1.8.0_66 latest

bins="java javac jar keytool"
for i in ${bins}; do
	alternatives --install /usr/bin/${i} ${i} /usr/java/latest/bin/${i} 0	
	alternatives --set ${i} /usr/java/latest/bin/${i}
done
java -version

echo
echo ">> Enabling and starting services, please wait..."
echo
for i in mariadb tomcat httpd; do
	systemctl enable ${i}
	systemctl start ${i}
done

echo
echo ">> All done! "
echo
cat /etc/motd
echo
sudo -H -u vagrant curl http://manager:Manager123@localhost/manager/text/serverinfo
sudo -H -u vagrant curl http://manager:Manager123@localhost/manager/text/list

