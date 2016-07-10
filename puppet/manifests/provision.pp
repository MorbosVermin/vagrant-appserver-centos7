#
# Copyright (c)2015 NASA GSFC ICAM
# Mike Duncan <michael.d.duncan@nasa.gov>
#
# Simple provisioning of a Tomcat-based application server. Default username and
# password for the deployment of applications to the server is 'manager' and
# 'Manager123' respectively. Access the application through Apache for which the 
# traffic is forwarded from tcp/8080 on the host to tcp/80 on the guest. This 
# will also ensure that Oracle JDK v8u66 is installed and used.
#

# Initial Configurations
file { '/etc/motd':
	ensure => file,
	mode => 644,
	owner => 'root',
	group => 'root',
	source => 'puppet:///modules/baseconfig/etc/motd'
}

file { '/home/vagrant/.bashrc':
	ensure => file,
	mode => 644,
	owner => 'vagrant',
	group => 'vagrant',
	source => 'puppet:///modules/baseconfig/home/vagrant/.bashrc'
}

file { '/home/vagrant/bin/deploy':
	ensure => file,
	mode => 755,
	owner => 'vagrant',
	group => 'vagrant',
	source => 'puppet:///modules/baseconfig/home/vagrant/bin/deploy'
}

# Services
$prereqs = [ "mariadb", "mariadb-server", "httpd-devel", "mod_ssl", "git", "tomcat", "tomcat-webapps", "tomcat-admin-webapps" ]
$services = [ "httpd", "mariadb", "tomcat" ]

# Ensure required packages are installed.
package { $prereqs:
	ensure => installed

# Install Oracle JDK
} -> exec { "sh /vagrant/packages/install-java.sh":
	path => "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin",
	cwd => "/vagrant/packages",
	unless => 'test -f /usr/java/latest/bin/java'

# Apache Configuration
} -> file { '/etc/httpd/conf.d/z-site.conf':
	ensure => file,
	mode => 644,
	owner => 'root',
	group => 'root',
	source => 'puppet:///modules/baseconfig/etc/httpd/conf.d/z-site.conf',

# MySQL/MariaDB Configuration
} -> file { '/etc/my.cnf':
	ensure => file,
	mode => 644,
	owner => 'root',
	group => 'root',
	source => 'puppet:///modules/baseconfig/etc/my.cnf',

# Tomcat Configurations	
} -> file { '/etc/tomcat/server.xml':
	ensure => file,
	mode => 644,
	owner => 'root',
	group => 'root',
	source => 'puppet:///modules/baseconfig/etc/tomcat/server.xml',
	
} -> file { '/etc/tomcat/tomcat-users.xml':
	ensure => file,
	mode => 644,
	owner => 'root',
	group => 'root',
	source => 'puppet:///modules/baseconfig/etc/tomcat/tomcat-users.xml',

# Ensure services are running. See http://www.puppetcookbook.com/posts/ensure-service-started-on-boot.html.	
# This does not seem to run systemctl enable ... though. So, it does not appear to work on CentOS 7. 
#} -> service { $services:
#	ensure => true
#
#} ->

# CentOS 7 workaround
} -> 
exec { "/usr/bin/systemctl start mariadb": } ->
exec { "/usr/bin/systemctl start tomcat": } ->
exec { "/usr/bin/systemctl start httpd": } ->
exec { "/usr/bin/systemctl enable httpd": } ->
exec { "/usr/bin/systemctl enable tomcat": } ->
exec { "/usr/bin/systemctl enable mariadb": }

