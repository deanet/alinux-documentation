--- 
layout: post
title: How to install Plugin Architecture Cacti and Mysql template for cacti
date: 2009-06-03 03:06:16
---

##Update: 25/6/2009

The Plugin Architecture for Cacti was designed to be both simple in nature and robust enough to allow freedom to do almost anything in Cacti. Cacti itself is designed nicely enough that integrating into it is fairly easy with very little modifications necessary. `teMySQLcacti` is A highly-modified version of MySQL monitoring templates for Cacti. You import a single host, which includes a bunch of graphs and graph types. To install it you must install Plugin Architecture Cacti first.

##Preparing to install Plugin Architecture Cacti:

####1. Fresh installation cacti (recommanded)

Recommanded using fresh installation cacti or your cacti will not work. You can see how to install cacti on <a href="/2009/05/26/how-to-install-cacti-0-8-7d.html" target="_new">previous post</a>.

####2. Download and extract

Download on <a href="http://cactiusers.org/downloads/patches/" target="_new">this page</a>

	# cd /temp-directory/plugin/architecture/cacti/
	# wget -c http://mirror.cactiusers.org/downloads/plugins/cacti-plugin-0.8.7d-PA-v2.4.zip
	# tar -zvxf cacti-plugin-arch.tar.gz


##Installing Plugin Architecture Cacti:

####1. Patch cacti

change into your cacti directory and patching

	# cd /srv/www/htdocs/cactifresh
	# patch -p1 -N &lt; /directory/plugin/architecture/cacti/cacti-plugin-0.8.7d-PA-v2.4.diff

####2. Configration cacti

edit file global.php.   Edit this to point to the default URL of your Cacti install  ex: if your cacti install as at `http://serverip/cactifresh/` this would be set to `/cactifresh/` .

	$config['url_path'] = '/cactifresh/';

to more information how to add cacti plugins, you can see on <a href="http://wowtutorial.org/tutorial/203.html" target="_blank">this page</a>


##Installing Mysql template for cacti:

####1.  Download and extract package from <a href="http://www.faemalia.net/mysqlUtils/" target="_new">this page</a>

	# cd /temp-directory/plugin/mysql
	# wget -c http://www.faemalia.net/mysqlUtils/teMySQLcacti-20060810.tar.gz
	# tar -xzvf teMySQLcacti-20060810.tar.gz

####2. copy `mysql_stats.php` and `dumpMemcachedStats.php` on `/srv/www/htdocs/cactifresh/scripts/`

####3. Make sure your cacti poller running with cron daemon every `1 minutes`. U can use spine, see on previous page.

####4. Import xml template . ex: `cacti_host_template_x_db_server_ht_0.8.6i.xml`

####5. Login into your cacti website then Create new device within new template ( `cacti_host_template_x_db_server_ht_0.8.6i.xml` ) .

####6. Done.


Reference:
1. [wiki cacti user](http://cactiusers.org/wiki/PluginArchitectureInstall)
2. [femalia.net](http://www.faemalia.net/mysqlUtils/)
3. [List cacti plugin template](http://forums.cacti.net/about15067.html)
4. [wowtutorial.org](http://wowtutorial.org/tutorial/203.html)
.
