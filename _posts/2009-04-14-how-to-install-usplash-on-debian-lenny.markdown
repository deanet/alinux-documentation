--- 
layout: post
title: How to Install Usplash on debian lenny
date: 2009-04-16 16:00:23
---
Boring with your lenny cause print text mode on kernel message ? . You must try this application called `usplash`. it's cool splash screen to change your text message. Many various installation `usplash` on linux distribution. On debian based u've just typed `apt-get` to install it. Easy ??? yeah.... let's go to prepare installation.

open your favourite `konsole`, then type:


	sudo apt-get install usplash usplash-theme-debian


edit configuration u need on `/etc/usplash.conf`. also add parameter `vga=791` `splash=verbose` on your `grub` like this:


	title        Debian GNU/Linux lenny
	root         hd0,9)
	kernel	     /boot/vmlinuz-2.6.26-1-686 root=/dev/sda10 rw ramdisk_size=10000 init=/etc/init lang=us vga=791 splash=verbose
	initrd	     /boot/initrd.img-2.6.26-1-686

after configure it, u must build your new `initram` with command:


	sudo dpkg-reconfigure usplash


and reboot ;)

## tips

To change theme usplash you just change symbolic link on `/etc/alternatives/usplash-artwork.so` to your `theme_name.so` .

	sudo ln -s /path/your/directory/theme_name.so  /etc/alternatives/usplash-artwork.so

you can try change your theme with [MacX Usplash Theme 1.2](http://gnome-look.org/content/show.php/MacX+Usplash+Theme?content=73611) .

gudlak ;)

## Reference:
1. [codehermit.ie](http://www.codehermit.ie/blog/?postid=89)
2. [MacX Usplash Theme 1.2](http://gnome-look.org/content/show.php/MacX+Usplash+Theme?content=73611)
