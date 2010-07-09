--- 
layout: post
title: Install Cacti, Spine, Memcached, Better MySQL Cacti Template on FreeBSD 7.2
date: 2010-01-10 10:00:00
---

On this tutorial i would like review how to install cacti. But small differents of previous tutorial. Now, i try out with FreeBSD 7.2. Cacti, Memcached, Spine via ports and Better MySQL Cacti Template.
ok,.. let's prepare :

#Install Cacti:

####1. Cacti needs web server and mysql server.
Please <a href="/2009/06/17/install-apache-php5-and-mysql-on-freebsd-7-2-using-ports.html" target="_new">Check this out</a> to install web server and mysql server on FreeBSD 7.2 . Make sure php module enable for webserver apache2, also `sockets`, `snmp` and `xml` modul for `php`. Those checked by `pkg_info | grep php`. If those aren't system, please install:
	
	# cd /usr/ports/net/php5-sockets; make install clean
	# cd /usr/ports/net-mgmt/php5-snmp; make install clean
	# cd /usr/ports/net/php5-xmlrpc; make install clean

####2. Cacti needs RRD TOOL

to install `rrdtool` change to into directory below and `make install clean`

	# cd /usr/ports/databases/rrdtool; make install clean

On this step, you can install cacti, please see previous posting <a href="/2009/05/26/how-to-install-cacti-0-8-7d/" target="_new">how to install cacti </a> (Step 4)

Make sure cacti running fine.. ;) and then install spine..


#Install Spine

####Via Ports:

	# cd /usr/ports/net-mgmt/cacti-spine
	# make install clean

when `cacti-spine` installed, these package included:

	libtool-1.5.26
	net-snmp-5.4.2.1_3

####Via Source:

####1. extract package

	# tar -xzvf cacti-spine-0.8.7c.tar.gz

####2. Configure, make and make install :)

	# cd cacti-spine-0.8.7c
	# ./configure && make && make install

If you installing `cacti-spine` via source, please make sure `net-snmp` installed too

	%pkg_info | grep snmp
	net-snmp-5.4.2.1_3  An extendable SNMP implementation

	# cd /usr/ports/net-mgmt/net-snmp

Please choose one how to install spine. Maybe you need more specific installation when install spine via source if you won't replace binary spine from port. Use option `--prefix=/your/own/folder` in example when you type `make install`.
ok, until here install `spine` or `cacti-id` is done. You need hard configuration now !.. :lol:

####3. Configuring spine:

####1. Copying `spine.conf` and configuring it

	{% highlight xml %}
	# cd /usr/local/spine/etc
	# cp spine.conf.dist spine.conf

	# vi spine.conf
	DB_Host         localhost
	DB_Database     cacti
	DB_User         cactiuser
	DB_Pass         cactipassword
	DB_Port         3306
	{% endhighlight %}

####2. Disable crontab poller cacti

`#* * * * * /usr/bin/php /srv/www/htdocs/cacti/poller.php > /dev/null 2>&1`

try to keep your database cacti and rra isn't gone or error :D

####3. Change `poller` configuration on cacti
a. Fill path spine
click `settings` >> `Path`. Fill spine path on path form, and then click `save`

b. change poller configuration

click `settings` >> `Poller`. Set poller with `spine` not `cmd-php` and then click `save`


##others configuration:

####1. Update value of poller on database

default value of poller on cacti database are `300 seconds`. We can change that value via mysql console

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


####2. Remove rra data on rra directory.

Remove old rra data that does not confuse with the new data of spine poller. Backup first if u not sure what r u doing.

	# cd /srv/www/htdocs/cacti/rra
	# tar -czvf /srv/www/htdocs/backup-rra.tar.gz *

then u can remove rra data

	# rm *

####3. Set crontab time for 1 minutes

	* * * * * /usr/bin/php /srv/www/htdocs/cacti/poller.php &gt; /dev/null 2&gt;&amp;1

Finish..

check your log to make sure spine is running .. ;)


#Install memcached and Better MySQL Cacti Templates

We use <a href="http://code.google.com/p/mysql-cacti-templates/" target="_new">MySQL Cacti Template</a> for create better Cacti templates for MySQL, Apache, Memcached and more.  And we use ssh based templates to create graphics of other machine which `snmpd` run, so we need create public key and secret key to automatic login on that machine. And next, Install MySQL Cacti Template based ssh.

	# tar zxf better-cacti-templates-1.1.4.tar.gz
	# cd better-cacti-templates-1.1.4
	# cp better-cacti-templates/scripts/ss_get_by_ssh.php /usr/local/www/cacti/scripts/

Now import the template files through your web browser. In the Cacti web interface's `Console tab`, click on the `Import Templates` link in the left sidebar. Browse to the directory containing the unpacked templates, `select` the XML file for the templates you're installing, and `submit` the form. In our example, the file will be named something like `cacti_host_template_x_mysql_server_ht_0.8.6i-sver1.1.4.xml`

##Configuration:

and then you need set auto login for ssh user as your username. see <a href="/2010/01/03/ssh-openssh-and-sftp-f-secure-auto-login-without-password/" target="_new">previous post how to make auto login</a>.

next, need some modified of script:

	# cd  /usr/share/cacti/site/scripts/
	# vi ss_get_by_ssh.php.cnf
	$ssh_user   = 'username';
	$ssh_iden   = '-i /your/locate/id_rsa';

done.

On others machine (server monitored, ex: `172.16.0.22`) install `memcached` from `ports`:

	# cd /usr/ports/databases/memcached
	# make install clean

start daemon:

	/usr/local/bin/memcached -m 4000 -d -u nobody

-m : memori
-d : sebagai daemon
-u : user

####boot daemon:

add to `rc.conf` for `memchaced` daemon activated every boot.

	memcached_enable="YES";
	memcached_flags="-t 8 -m 4000";

Testing your ssh based Templates. Run this command on cacti's machine:

	%/usr/local/bin/php /usr/local/www/cacti/scripts/ss_get_by_ssh.php --type memcached --host 172.16.0.22 --items b6,b7
	b6:4846539 b7:8779665%

and then just <a href="http://gregsowell.com/?p=115" target="_new">create graph for new device</a>.


#Troubleshoot:

If u got an error:

	Call to undefined function session_name()

just install via ports:

	# /usr/ports/www/php5-session
	# make install clean

done...

good luck... ;)

semoga bermanfaat.. :)


reference:
1. <http://code.google.com/p/mysql-cacti-templates/wiki/InstallingTemplates>
2. <http://code.google.com/p/mysql-cacti-templates/wiki/SSHBasedTemplates>
