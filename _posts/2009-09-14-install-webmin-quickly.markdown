--- 
layout: post
title: Install webmin quickly
date: 2009-09-14 16:37:55
---

Webmin is a web-based interface for system administration for Unix. Using any modern web browser, you can setup user accounts, Apache, DNS, file sharing and much more. Webmin removes the need to manually edit Unix configuration files like `/etc/passwd`, and lets you manage a system from the console or remotely.

##Installation:

	# wget http://prdownloads.sourceforge.net/webadmin/webmin-1.480.tar.gz
	# tar -xzvf webmin-1.480.tar.gz
	# cd webmin-1.480/
	# ./setup.sh /usr/local/webmin

when script is running it will copy to `/usr/local/webmin`. so, just hit enter or fill with match question.

To reset Password just enter like this:

	#/usr/local/webmin-1.140/changepass.pl /etc/webmin admin foo

Reference:
1. [http://skleton.wordpress.com/2009/06/22/install-webmin](http://skleton.wordpress.com/2009/06/22/install-webmin)
