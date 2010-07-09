--- 
layout: post
title: How to change port and enable log OpenSSH SSH daemon
date: 2009-06-07 07:06:12
---

The syslog-ng application is a flexible and highly scalable system logging application that is ideal for creating centralized logging solutions. The main features of syslog-ng are; reliable log transfer, secure logging using SSL/TLS, IPv4 and IPv6 support and many others" (Syslog-ng, 2008).

##Problem:
On Linux Suse enterprise version, log ssh saved into `/var/log/messages` , or opensuse 11 like my machine doesn't noticed into `/var/log/messages`. So we have a solution, what is solution ??

##Solution:
we can add option `log` on `syslog-ng` and noticed into self directori or self file. example: `sshderr.log` for error access and `sshd.log` for enable access into directori `/var/log/sshd`.

##Prepare:
####1. Make sure syslog-ng have been installed on your machine.

	# rpm -qa | grep syslog
	syslog-ng-1.6.12-76.2

if nothing of results, you can install by `yast`:

	# yast2 -i syslog-ng

####2. Make sure openssh daemon is running


	# ps aux | grep sshd


if not running, assumed we use `opensuse 11` type,:

	/etc/init.d/sshd start

####3. Make sure enable `SyslogFacility` on `/etc/ssh/sshd_config`

	SyslogFacility AUTH


##Configuration:

####1. Create directory `/var/log/sshd`

	# mkdir /var/log/sshd

####2. create two empty files into directori `/var/log/sshd`

	# touch /var/log/sshd/sshderr.log
	# touch /var/log/sshd/sshd.log

####3. add some option into `/etc/syslog-ng/syslog-ng.cnf`

	# SSH Filters
	filter f_sshderr    { match('^sshd\[[0-9]+\]: error:'); };
	filter f_sshd       { match('^sshd\[[0-9]+\]:'); };
	# SSH Logging
	destination sshderr { file("/var/log/sshd/sshderr.log"); };
	log { source(src); filter(f_sshderr); destination(sshderr); flags(final); };
	destination sshd { file("/var/log/sshd/sshd.log"); };
	log { source(src); filter(f_sshd); destination(sshd); flags(final); };

####4. Restart service

Suseconfig service:

	# SuSEconfig
	Starting SuSEconfig, the SuSE Configuration Tool...
	Running in full featured mode.
	Reading /etc/sysconfig and updating the system...
	Executing /sbin/conf.d/SuSEconfig.glib2...
	[Default Applications]
	application/x-redhat-package-manager=package-manager.desktop
	application/x-rpm=package-manager.desktop
	Executing /sbin/conf.d/SuSEconfig.groff...
	Executing /sbin/conf.d/SuSEconfig.permissions...
	Finished.

Syslog-ng service:

	# service syslog restart
	Shutting down syslog services                                         done
	Starting syslog services                                              done

done. finish.

now u can test by remote machine with ssh. try make error and repeat remote that make accessable. see ssh log:

error log:
	
	# cat /var/log/sshd/sshderr.log
	Jun  1 06:34:37 dhanuxe sshd 1579: error: PAM: Authentication failure for deanet from 125.208.155.134

accessable log:

	dhanuxe:/home/deanet # cat /var/log/sshd/sshd.log
	Jun  1 06:34:35 dhanuxe sshd 1579: reverse mapping checking getaddrinfo for 125.208.155.134.cbn.net.id [125.208.155.134] failed - POSSIBLE BREAK-IN ATTEMPT!
Jun  1 06:34:44 dhanuxe sshd 1579: Accepted keyboard-interactive/pam for deanet from 125.208.155.134 port 1996 ssh2

####Change Port
To change ssh service you can edit following file `/etc/ssh/sshd_config`

	Port 22


gud lak ;)

Reference:

1. [forum.opensuse.org](http://forums.opensuse.org/network-internet/415433-sshd-log-file.html)
2. [novell.com](http://www.novell.com/communities/node/5003/syslog-ng-ssh-logging)
