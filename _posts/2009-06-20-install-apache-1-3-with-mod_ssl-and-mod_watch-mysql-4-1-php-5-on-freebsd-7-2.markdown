--- 
layout: post
title: Install Apache 1.3 with mod_ssl and mod_watch, Mysql 4.1, PHP 5 on FreeBSD 7.2
date: 2009-06-21 21:00:06
---

Same as previous posting, we have installed apache 2 , mysql 5.x and php 5. On this posting now, we'll try install apache 1.3 with mod_ssl and mod_watch, MySQL 4.1 and PHP 5.

##Installation:

####Apache 1.3

to install apache 1.3 with `mod_ssl` :

	# cd /usr/ports/www/apache13-modssl
	# make install clean

to start just type

	# /usr/local/sbin/apachectl start

to enable apache on boot add `apache_enable="YES"` following file `/etc/rc.conf`

check apache on your browser type localhost / 127.0.0.1 / ip address

install `mod_watch`

	# wget ftp://ftp.freebsd.org/pub/FreeBSD/ports/distfiles/mod_watch318.tgz
	# tar -xzvf mod_watch318.tgz
	# cd mod_watch
	# make install-dynamic

##PHP 5

	# cd /usr/ports/www/lang/php5

make sure to build Apache module is `checked`

add these option on file `/usr/local/etc/apache/httpd.conf`

	{% highlight apacheconf %}
	AddType application/x-httpd-php .php
	AddType application/x-httpd-php-source .phps
	{% endhighlight %}
create file `php.ini` by copy `php.ini-dist`

	# cd /usr/local/etc/
	# cp php.ini-dist php.ini

and then restart apache

	# /usr/local/sbin/apachectl restart

create file php on `/usr/local/www/apache22/data/`

	<?php phpinfo();?>

save as `test.php`

now test on your browser `http://127.0.0.1/test.php`

.

##MySQL 4.1
	
	# cd /usr/ports/databases/cd mysql41-server/

####create database

	# /usr/local/bin/mysql_install_db

####change owner and group as mysql

	# chown -R mysql /var/db/mysql/
	# chgrp -R mysql /var/db/mysql/

####run mysql daemon

	/usr/local/bin/mysqld_safe user=mysql &


####change mysql password

	/usr/local/bin/mysqladmin -u root password newpass

to automatic msyql enable when boot add `/etc/rc.conf`:

	mysql_enable="YES"


##Install PHP5-MySQL Module

	cd /usr/ports/databases/php5-mysql
	make install clean

create file php to check it

	{% highlight php %}
	<?php
	$test=mysql_connect("localhost","mysql","");
	if(!$test)
	{
	print "cant connect";
	}
	else
	{
	print "connected";
	}
	?>
	{% endhighlight %}

save as `test-db.php` on `/usr/local/www/apache22/data/` and go to your browser `http://localhost/test-db.php`

done.

Reference:

1. [previous post](/2009/06/17/install-apache-php5-and-mysql-on-freebsd-7-2-using-ports)
