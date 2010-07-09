--- 
layout: post
title: Update package failed on ports FreeBSD
date: 2010-02-27 03:02:01
---
This is simple log error when we've failed to install package on freebsd via ports:

{% highlight xml %}
===>;;  Checking if databases/mysql50-client already installed
===>;;   An older version of databases/mysql50-client is already installed (mysql-client-5.0.77_1)
You may wish to ``make deinstall'' and install this port again
by ``make reinstall'' to upgrade it properly.
If you really wish to overwrite the old port of databases/mysql50-client
without deleting it first, set the variable &quot;FORCE_PKG_REGISTER&quot;
in your environment or the &quot;make install&quot; command line.
*** Error code 1

Stop in /usr/ports/databases/mysql50-client.
*** Error code 1

Stop in /usr/ports/databases/py-MySQLdb.
*** Error code 1

Stop in /usr/ports/databases/py-MySQLdb.
cacti#
{% endhighlight %}

where those package was installed.

	cacti# pkg_info | grep mysql
	mysql-client-5.0.77_1 Multithreaded SQL database (client)
	mysql-client-5.0.88 Multithreaded SQL database (client)
	mysql-server-5.0.77_1 Multithreaded SQL database (server)
	php5-mysql-5.2.11_1 The mysql shared extension for php
	cacti#

so, to force package:

	setenv FORCE_PKG_REGISTER 1

and then run command again ;)

Reference:
<http://freebsd.munk.me.uk/archives/199-Portupgrade-fails-to-upgrade-dependencies.html>
