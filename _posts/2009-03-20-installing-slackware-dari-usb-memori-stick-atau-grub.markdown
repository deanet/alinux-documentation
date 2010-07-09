--- 
layout: post
title: Installing Slackware dari USB memori Stick atau GRUB
date: 2009-03-20 20:00:00
---
Hari gini install linux pake CD ?? ogak bangets.. :D. install slackware pake USB ??. Maknyuss banget ... Gak ada USB ?? install pake Grub ?? TOP Bangetss ...:D

Yang mesti dibutuhin

**1. ISO Slackware**<br/>
**2. USB memori stick ato flashdisk**<br/>
**3. [lilo](http://freshmeat.net/projects/lilo/)**<br/>

lilo mesti di install dulu biar bisa boot pake USB. kalo belum diinstall, download aj executable nya di [linux-live](http://linux-live.org). Di situ ada koq, uda komplit utk linux, win juga ada (gak dibahas). Klo males dunlud, y pake grub aja :P.

Disini dalam percobaan pake distro slackware 12.1 . Lansung saja mount iso na dg opsi loop dan copy isinya ke direktori terserah.

## Dengan USB memori Stick ato Flash Disk

**1. Menyiapkan bahan installasi untuk Hardisk:**
mount iso na

	mount /mnt/sda4/iso/slackware/slackware-12.1-install-d1.iso tmp/ -o loop

lalu copy isi iso na ke `/home/terserah` misalnya.

	cp -a tmp/* /home/terserah

**2. Menyiapkan bahan installasi untuk USB:**

mount file `usbboot.img` yg ada di `/home/terserah/usb-and-pxe-installers` dg loop.

	mkdir usb
	mount /home/terserah/usb-and-pxe-installers/usbboot.img usb/ -o loop

**3. Menyiapakan alat perang:**

mount USB Flashdisk na lalu kopi isi file `usbboot.img` tadi

	mount /mnt/sdb1
	cp usb/* /mnt/sdb1

terus bikin supaya USB na bisa booting ..

	lilo -S /dev/null -M /dev/sdb ext
	lilo -S /dev/null -A /dev/sdb 1

selesai n reboot ...

##Dengan Grub
tambahkan di `Grub` kalo mo pake `Grub`:

	title           Slackware Installer - older machine
	root            (hd0,3)
	kernel          /huge.s rw
	initrd          /initrd.img

	title           Slackware Installer - i486 machine
	root            (hd0,3)
	kernel          /hugesmp.s rw
	initrd          /initrd.img


Pastikan sudah mengkopi isi file `usbboot.img` tadi ke partisi 4 `(hd0,3)`
	
	cp usb/* /mnt/sda4

selesai.. reboot n pilih menu grubna


**tips:**

kalo mau cepet gak pake lilo utk bisa booting na pake cara ini (tidak dianjurkan tapi masih manjur):
	
	dd if=usbboot.img of=/dev/sdb bs=512

**warning**

hati2 jgn sampe salah nama device na. :) . terus reboot, n seharusnya uda bisa booting.

cara diatas (perintah dd) akan membuat partisi usb menjadi kacau balau (lihat pake `fdisk -l`). untuk mngembalikannya pake `dd` lagi.

	dd if=/dev/zero of=/dev/sdb bs=512 count=1

terus ketik:

	fdisk /dev/sda <<eof
	n
	p
	1

	t
	b
	w
	EOF

format dg partisi vfat

	mkdosfs -F32 /dev/sda1

slesai ..


**Referensi:**

1. Manual READ ME (include ON CD ISO Slackware)
2. [slacware:usbboot](http://www.slackware.com/~alien/dokuwiki/doku.php?id=slackware:usbboot)
