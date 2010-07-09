--- 
layout: post
title: Installing Debian Lenny from a USB memory stick (USB HDD)
date: 2009-01-23 03:16:23
---

**last Update 22 May 2010**

i was doing this on slax machine to create bootable usb memory stick debian lenny.

needed things:

1. [lilo](http://freshmeat.net/projects/lilo/)
2. [mbr package](http://packages.debian.org) optional.
3. [syslinux](http://syslinux.zytor.com/).
4. vmlinuz, initrd.gz and boot.img.gz (optional). download on [here](http://ftp.nl.debian.org/debian/dists/lenny/main/installer-i386/current/images), choose hd-media directory. Thats i386 machine, for Others Machine try download on [here](http://www.debian.org/devel/debian-installer/)
5. USB HDD (i use Kingston Data Traveler 2.0, 4G storage called USB HDD). maybe with USB key possible to install.
6. ISO can download on [here](http://cdimage.debian.org)
before do this, your `lilo` (or `mbr package`) and `syslinux` must installed (check first on your konsole with syslinux command). then, next step are:


**1. creating fat filesystem:**

	mkdosfs /dev/sdb1


**2. creating `ldlinux.sys` on your USB memory stick:**

	syslinux /dev/sdb1


**3. open your favourite editor and fill:**
<a name="textmode">.</a>

	default /vmlinuz vga=791
	append initrd=/initrd.gz

save as `syslinux.cfg` and copy `syslinux.cfg`, `vmlinuz, initrd.gz` to `/mnt/sdb1`:

	cp {syslinux.cfg,vmlinuz,initrd.gz} /mnt/sdb1


**4. also your lenny ISO:**

	cp /mnt/sda4/iso/debian-sid-lenny-cd/debian-testing-i386-CD-1.iso /mnt/sdb1/


**5. then make bootable your USB memory stick, on konsole type:**

	lilo -S /dev/null -M /dev/sdb ext
	lilo -S /dev/null -A /dev/sdb 1


for mbr package:


	install-mbr /dev/sdb


your USB memory stick should be bootable now and possible to install debian lenny using USB memory stick :)

done.

**Tips:**

to install with graphical install you can ignore step 3 and copy all things on `boot.img.gz` ( `gunzip` & mount it with loop before or doing with zcat command).

### with loop

	mkdir tmp
	gunzip boot.img.gz
	mount boot.img tmp/ -o loop


copy all things on tmp to `/mnt/sdb1`

	cp tmp/* /mnt/sdb1


or u can using `vmlinuz` and `kernel` (`initrd`) from [directory gtk](http://ftp.nl.debian.org/debian/dists/lenny/main/installer-i386/current/images/hd-media). Replace `vmlinuz` and `initrd` <a href="#textmode">on text mode</a> based with them.

### with zcat

	zcat boot.img.gz >/dev/sdb1


using `zcat`, your usb stick will partitioned 250 M. so,you must use ISO smaller than 250 M. (`netinst` or etc)

and you can continued next step (step 4)

Reference:

1. [Installing Debian Sarge from a USB memory stick (USB key)](http://d-i.pascal.at)
2. [Installing Debian from a USB Stick](http://h0bbel.p0ggel.org/installing-debian-from-a-usb-stick)
3. [Install GNU/Linux Debian Etch dari USB Flash Disk](http://zuyyin.wordpress.com/2008/05/06/install-gnulinux-debian-etch-dari-usb-flash-disk/)
