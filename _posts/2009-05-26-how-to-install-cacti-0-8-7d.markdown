--- 
layout: post
title: How to install Cacti 0.8.7d
date: 2009-05-26 01:00:05
---
##About Cacti

Cacti is a complete network graphing solution designed to harness the power of RRDTool's data storage and graphing functionality. Cacti provides a fast poller, advanced graph templating, multiple data acquisition methods, and user management features out of the box. All of this is wrapped in an intuitive, easy to use interface that makes sense for LAN-sized installations up to complex networks with hundreds of devices.

so, let's do it :
On this experiment I use openSUSE 11. U can try on debian based or ubuntu. see <a href="http://open4energy.com/tutorials/virtualbox/cacti" target="_blank">this page</a> for more info :).

###1. Prepare web server and Database server

At this point we'll prepare web server dan database server. you can view how to install web server and database server on <a href="/2009/05/05/installasi-bind-apache2-mysql-php-dan-konfigurasi-dns-serta-virtual-host-di-opensuse.html" target="_new">here</a> with indonesian language. But don't worry, u can also see english version on <a href="http://tech-db.com/node/43" target="_new">this page</a>.

you can check or make sure webserver(apache) and database server (mysql) installed on your machine. on open suse 11 we can check apache with command:

	# rpm -qa | grep apache2

and mysql

	# rpm -qa | grep mysql


###2. Prepare php-snmp module

just type like this to install php5-snmp module:

	# yast2 -i php5-snmp

that automatically install:

	net-snmp-5.4.1-77.4
	snmp-mibs-5.4.1-77.4
	libsnmp15-5.4.1-77.4
	php5-snmp-5.2.9-0.1
	net-snmp-devel-5.4.1-77.4

check with rpm -qa | grep snmp to make sure like on list. if isn't on list, u can install step by step list module.

###3. Prepare rrdtool

at least, we've two way to install `rrdtool`. pls choose use binary. If rrdtool not recognized by `cacti`, u must compile rrdtool from source.

####a. Use binary from repositori.

we can type:

	# yast2 -i rrdtool

that automatically install:

	rrdtool-1.2.27-22.1
	rrdtool-devel-1.2.27-22.1

check with rpm -qa | grep rrdtool to make sure like on list. if isn't on list, u can install step by step list module.

####b. Compile from source

	# wget http://oss.oetiker.ch/rrdtool/pub/rrdtool-1.3.8.tar.gz
	# tar -xzvf rrdtool-1.3.8.tar.gz;cd rrdtool-1.3.8
	# ./configure && make && make install

**NOTE**
Installing dependencies:

	glib-2.15.4.tar.gz
	cairo-1.6.4.tar.gz
	pango-1.21.1.tar.bz2

dependencies package download recommanded from <a href="http://oss.oetiker.ch/rrdtool/pub/libs/" target="_new">here</a>

Get package, extract package, change to work directory and install

	# aclocal
	# autoheader
	# autoconf
	# automake
	# ./configure
	# make
	# make install

please see install or readme files on package for information :)

###4. Installing Cacti

Go to the <a href="http://www.cacti.net/download_cacti.php" target="_new">download page</a> to download cacti.

####4.1. Put `cacti-0.8.7d.tar.gz` into directory can access on site.
example: root directory on `example.com` is `/srv/www/htdocs` . so put `cacti-0.8.7d.tar.gz` into `htdocs` directory and extract.

	# tar -xzvf cacti-0.8.7d.tar.gz

####4.2. rename directory `cacti-0.8.7d` to cacti be simply use and change directory to it

	# mv cacti-0.8.7d cacti; cd cacti

####4.3. add group cacti

	# groupadd cacti

and user for cacti

	# useradd -g cacti cactiuser

####4.3. change password for cacti user

	# passwd cactiuser

Now, Installing cacti database and make sure cacti user to have privileges

####4.4. create database cacti

	# mysqladmin -u root -p create cacti

####4.5. dump cacti database

	# mysql -u root -p cacti < cacti.sql

####4.6. set privileges cacti database to cacti user

	# mysql -u root -p
	mysql> GRANT ALL ON cacti.* TO cactiuser@localhost IDENTIFIED BY ‘cactipassword’;
	mysql> flush privileges;

####4.7. Edit Configuration config.php

	# vi include/config.php
	/* make sure these values refect your actual database/host/user/password */
	$database_type = “mysql”;
	$database_default = “cacti”;
	$database_hostname = “localhost”;
	$database_username = “cactiuser”;
	$database_password = “cactipassword”;
	$database_port = “3306";

####4.8. set permission rra and log directory to cactiuser

	# chown -R cactiuser rra/ log/

####4.9. make cron schedule with crontab

	# crontab -e

type `a` and fill like this

	*/1 * * * * /usr/bin/php /srv/www/htdocs/cacti/poller.php > /dev/null 2>&1

type `esc` and `:w` to write, and type `q` to quit .

####4.10. access it from site `example.com/cacti`
results:

click `next` >> choose `new install` >> choose `net-snmp 5.x` and `rrdtool 1.2.x` . i use 1.3 version. so, make sure version that's true. and then click `Finish`

ok, just it :) . you can access now on `example.com/cacti` . use `admin` as user and `admin` as password. How to create and manage cacti ?, you can see video on <a href="http://gregsowell.com/?p=115" target="_new">this page</a>.


###Troubleshooting:

####1. Socket Error
get the error:
	
	Error
	The following PHP extensions are missing:
	* sockets

make sure Configure Command on `phpinfo` have

	--enable-sockets

if none, install `php5-sockets`

	# yast2 -i php5-sockets

if it's not resolve problem, you can recompile your php from source , googling :)

####2. Graphic not shown / Make sure `rrdtool` works as normally

maybe you got error like <a href="http://forums.cacti.net/about32632.html&amp;highlight=graphic+show" target="_new">this</a>

make sure your `rrdtool` can generate for graphic file. and try on konsole with type:

	/usr/local/rrdtool-1.3.8/bin/rrdtool graph /tmp/cacti.png - \
	--imgformat=PNG \
	--start=1243236410 \
	--end=1243322810 \
	--title="localhost - Load Average" \
	--rigid \
	--base=1000 \
	--height=120 \
	--width=500 \
	--alt-autoscale-max \
	--lower-limit=0 \
	--units-exponent=0 \
	COMMENT:"From 2009/05/25 08\:26\:50 To 2009/05/26 08\:26\:50\c" \
	COMMENT:"  \n" \
	--vertical-label="processes in the run queue" \
	--slope-mode \
	--font TITLE:12: \
	--font AXIS:8: \
	--font LEGEND:10: \
	--font UNIT:8: \
	DEF:a="/srv/www/htdocs/cacti/rra/localhost_load_1min_16.rrd":load_1min:AVERAGE \
	DEF:b="/srv/www/htdocs/cacti/rra/localhost_load_1min_16.rrd":load_5min:AVERAGE \
	DEF:c="/srv/www/htdocs/cacti/rra/localhost_load_1min_16.rrd":load_15min:AVERAGE \
	CDEF:cdefg=TIME,1243322526,GT,a,a,UN,0,a,IF,IF,TIME,1243322526,GT,b,b,UN,0,b,IF,IF,TIME,1243322526,GT,c,c,UN,0,c,IF,IF,+,+ \
	AREA:a#EACC00FF:"1 Minute Average"  \
	GPRINT:a:LAST:" Current\:%8.2lf\n"  \
	AREA:b#EA8F00FF:"5 Minute Average":STACK \
	GPRINT:b:LAST:" Current\:%8.2lf\n"  \
	AREA:c#FF0000FF:"15 Minute Average":STACK \
	GPRINT:c:LAST:"Current\:%8.2lf\n"  \
	LINE1:cdefg#000000FF:"\n"

that command will create file cacti.png on `/tmp` . you need modify that command where is rrd path location.

####3. Make sure snmp daemon running.

type this to make sure snmp daemon running on your machine:

	snmpwalk -c public -v 1 localhost system

it will results:

	SNMPv2-MIB::sysDescr.0 = STRING: Linux ddd.ssss.net 2.6.18-92.1.13.el5.028stab059.6 #1 SMP Fri Nov 14 20:22:51 MSK 2008 i686
	SNMPv2-MIB::sysObjectID.0 = OID: NET-SNMP-MIB::netSnmpAgentOIDs.10
	DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (53004148) 6 days, 3:14:01.48
	SNMPv2-MIB::sysContact.0 = STRING: Sysadmin (root@localhost)
	etc..

####4. make sure enough memory

type like this on konsole:

	/usr/bin/php cacti/poller.php

if output of console results :

	Out of memory

u must killall -9 something_daemon that running to reallocate new space of memory

####5. Always check cacti log on log directory

cmiiw :)

Reference:

1. [cacti.net](http://cacti.net)
2. [tech-db.com](http://tech-db.com/node/24)
3. [groundworkopensource.com](http://www.groundworkopensource.com/community/forums/viewtopic.php?f=23&amp;t=1317&amp;start=15)
4. [forums.cacti.net](http://forums.cacti.net/about32632.html&amp;highlight=graphic+show)
5. [oss.oetiker.ch](http://oss.oetiker.ch/rrdtool/doc/rrdbuild.en.html)
6. [gregsowell.com](http://gregsowell.com/?p=115)
