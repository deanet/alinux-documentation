--- 
layout: post
title: Disable user Login on FreeBSD
date: 2009-12-01 01:12:00
---
How to disable user login on FreeBSD ???

You need port collection, or you can download single file tarball no-login, put on `/usr/ports/distfiles/` and install via ports :) .

	# cd /usr/ports/sysutils/no-login
	# make install clean

configure:

type like below

	# vipw

Welcome on vi editor...
next, change shell login to `/usr/sbin/nologin`

in ex:

	deanet:*:1001:1001:deanet:/home/deanet:/usr/local/bin/bash

to be

	deanet:*:1001:1001:deanet:/home/deanet:/usr/sbin/nologin


now, try login. And check on `syslog`


	tail /var/log/messages


and .. vioolaa... :P

Reference:

1. [http://www.freebsddiary.org/nologin.php](http://www.freebsddiary.org/nologin.php)
