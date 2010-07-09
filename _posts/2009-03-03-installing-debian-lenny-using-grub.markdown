--- 
layout: post
title: Installing debian lenny using GRUB
date: 2009-03-03 03:03:16
---
on [previous post](/2009/01/23/installing-debian-lenny-from-a-usb-memory-stick-usb-hdd.html) we can install debian lenny using USB memori stick. Now, we will try install debian lenny using `grub`. So without burned on CD.

tools needed:

1. [Grub](http://freshmeat.net/projects/gnugrub/)
2. [vmlinuz and initrd](http://ftp.nl.debian.org/debian/dists/lenny/main/installer-i386/current/images/hd-media/).
3. [boot.img.gz](http://ftp.nl.debian.org/debian/dists/lenny/main/installer-i386/current/images/hd-media/) (optional)

okay,..

first step, `grub` must installed on your machine. Then, copy `vmlinuz` and `initrd` to partition. example: `sda4`

	cp {vmlinuz,initrd} /mnt/sda4

also your lenny ISO

	cp /mnt/sda3/iso/debian-sid-lenny-cd/debian-testing-i386-CD-1.iso /mnt/sda4/

Now, just adding list menu on `GRUB` like this:

	title           Debian Installer
	root            (hd0,3)
	kernel          /vmlinuz vga=791
	initrd          /initrd.gz[/sourcecode]

reboot and try it ...
maknyuss..... ;)

## Tips:

same as with previous post. we can using graphical installer using `boot.img.gz` . Extract it, and `mount` with `loop`. copy all needed.

	mkdir tmp
	gunzip boot.img.gz
	mount boot.img tmp/ -o loop

copy all things on tmp to `/mnt/sda4`

	cp tmp/* /mnt/sda4


add on list `grub`

	title           Debian Graphic Installer
	root            (hd0,3)
	kernel          /linux vga=791
	initrd          /initrdg.gz


done.

Reference:

1. [Debian Manual](http://debian.org/releases/stable/installmanuall)
