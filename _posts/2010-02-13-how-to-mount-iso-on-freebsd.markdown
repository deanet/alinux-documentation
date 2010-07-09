--- 
layout: post
title: How to mount iso on FreeBSD
date: 2010-02-13 13:00:02
---
Just simply to mount:

	%sudo mdconfig -a -t vnode -o readonly -f GRTMPOEM_EN.iso
	md0
	%sudo mount -t cd9660 /dev/md0 tmp/
	%ls tmp/
	autorun.inf     i386            setupxp.htm     win51
	docs            readme.htm      support         win51ip
	dotnetfx        setup.exe       valueadd        win51ip.sp3

semoga bermanfaat :)

Referensi:
1. <http://forums.freebsd.org/showthread.php?t=4932>
2. <http://www.freebsddiary.org/iso-mount.php>
