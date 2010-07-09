--- 
layout: post
title: How to install poller cactid or spine on linux
date: 2009-05-31 06:05:23
---
------------------------------------------
spine: a backend data gatherer for cacti
------------------------------------------
This code represents high speed poller replacement for cmd.php. It has come quite a ways from it's initial development.  It is 100% compatible with the legacy cmd.php processor. (Larry Adams aka TheWitness)

##Prepare:
####1. Make sure net-snmp-devel package have been installed on your machine.

	# rpm -qa | grep snmp

on my machine results:

	net-snmp-5.4.1-77.4
	snmp-mibs-5.4.1-77.4
	libsnmp15-5.4.1-77.4
	php5-snmp-5.2.9-0.1
	net-snmp-devel-5.4.1-77.4

if you dont have anything of package, install using `yast`. yeah, i'm using rh based / opensuse 11.

	# yast2 -i net-snmp

####2.  Get package from <a href="http://www.cacti.net/downloads/spine" target="_blank">www.cacti.net</a>

	# cd /usr/src
	# wget http://www.cacti.net/downloads/spine/cacti-spine-0.8.7c.tar.gz


##Installation spine:

####1. extract package

	# tar -xzvf cacti-spine-0.8.7c.tar.gz

####2. Configure, make and make install :)

	# cd cacti-spine-0.8.7c
	# ./configure && make && make install

##Configuring spine:

####0. Copying spine.conf and configuring it

	# cd /usr/local/spine/etc
	# cp spine.conf.dist spine.conf

	# vi spine.conf
	DB_Host         localhost
	DB_Database     cacti
	DB_User         cactiuser
	DB_Pass         cactipassword
	DB_Port         3306


####1. Set crontab time for 1 minutes

	* * * * * /usr/bin/php /srv/www/htdocs/cacti/poller.php > /dev/null 2>&1

####2. Change poller configuration on cacti</strong>
#####a. Fill path spine
click settings -&gt; Path . u will see like this:

<img src="http://numpanglewat.files.wordpress.com/2009/05/pathspine.png?w=300&h=36" border="0">

then click save

b. change poller configuration

click settings -&gt; Poller . u will see like this:

<img src="http://numpanglewat.files.wordpress.com/2009/05/pollerspine.png?w=300&h=91" border="0">


then click save

####others configuration:

#####1. Update value of poller on database

default value of poller on cacti database are `300 seconds`. We can change that value via `mysql console`

	# mysql -u root -p
	Enter password:
	Welcome to the MySQL monitor.  Commands end with ; or \g.
	Your MySQL connection id is 28894
	Server version: 5.0.77-community MySQL Community Edition (GPL)
	Type 'help;' or '\h' for help. Type '\c' to clear the buffer.

change into cacti database

	mysql> use cacti;
	Reading table information for completion of table and column names
	You can turn off this feature to get a quicker startup with -A
	Database changed

and update value of poller on database.

	mysql> update data_template_data set rrd_step='60';
	mysql> update data_template_rrd set rrd_heartbeat='120';
	mysql> flush privileges;

#####2. Remove rra data on rra directory.</strong>

Remove `old rra` data that does not confuse with the new data of `spine poller`. Backup first if u not sure what r u doing.

	# cd /srv/www/htdocs/cacti/rra
	# tar -czvf /srv/www/htdocs/backup-rra.tar.gz *

then u can remove rra data

	# rm *

Finish..

check your log to make sure spine is running .. ;)

<img src="http://numpanglewat.files.wordpress.com/2009/05/log.png?w=300&h=51" border="0">


##Troubleshooting:

if u got error like below when using spine version cacti-spine-0.8.7/a/c


	configure: error:


	*** [Gentoo] sanity check failed! ***
	*** libtool.m4 and ltmain.sh have a version mismatch! ***
	*** (libtool.m4 = 1.5.22, ltmain.sh = 1.5.26) ***

try using spine version 7c beta 2 on <a href="http://forums.cacti.net/about29486.html" target="_new">this page</a>

gud luck ;)

Reference:

1. [cacti.net](http://www.cacti.net/spine_install_rhlnx.php)
2. [human.network.web.id](http://human.network.web.id/2008/07/02/cacti-1-minute-polling/)
3. [forum cacti](http://forums.cacti.net/about29486.html)
