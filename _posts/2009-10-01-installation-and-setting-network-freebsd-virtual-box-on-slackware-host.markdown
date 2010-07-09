--- 
layout: post
title: Installation and setting network FreeBSD Virtual Box on Slackware Host
date: 2009-10-01 01:00:10
---
On <a href="/2009/06/12/installasi-freebsd-dan-setting-jaringan-freebsd-as-guest-di-vmware-server.html" target="_blank">previous posted</a> by me, we've installed FreeBSD on VmWare and setting networking for it. Now, we'll try install FreeBSD on VirtualBox and setting networking for it on Slackware host.

At first step. we must have installed Virtual Box. On this experiment, i use Virtual Box version 3.0.6 rxxxx and Slackware 12.0 as host. Just download on <a href="http://www.virtualbox.org/wiki/Linux_Downloads" target="_new">virtualbox.org</a> (choose linux all compability) and install it by execute binary file.

	./VirtualBox-xxx.run

Ok, now lets begin to install FreeBSD on Virtual Box using Slackware Host.

##Create new machine FreeBSD on Virtual Box

1. Run Virtual Box and Click Machine -&gt; New .. or using shortcut `Ctrl + N`

2. Click `Next` and give `name for machine`, choose `Type Operating System`, then `Version Os`. And click `next`.

3. At memory (RAM) for virtual machine, leave as `default`. Then Click `next`
4. Choose create `new Hardisk`, and click `next`

5. click `next`

6. choose `dinamically` bla ... bla.. bla.. , and click `next`

7. Type `name of Virtual Hardisk (leave as default)` .. and then choose `size of virtual hardisk`. On this experiment using 2G is enaugh. We'll install on minimum system ;) . so click `next` and click `Finish`

8. On summary Window, click next `Finish`.



##Install FreeBSD on new Virtual Machine

1. Choose `Machine (FreeBSD-7)`
2. Click `Setting`
3. Choose `CDROM` tab
4. Checked `Mount CD/DVD Drive option`
5. Checked `ISO Image File option`
6. Locate `ISO Image File`
7. Click `Yellow Arrow`
8. Click `Add`
9. Choose `File and open`, and `select`. at last, click `OK`.

##Now, click Start on virtual box
1. Press `Enter` for default.
2. Choose `country`, press `enter`, and press `enter` again (leave as default)
3. Choose `Standard installation`, press `enter`, and press `enter` again
4. Partitioning Disk on FreeBSD

	a. Type `a` to use all entire Disk, and type `q`.<br/>
	b. Press `enter` (we use FreeBSD boot manager), then `press` enter again.<br/>
	c. Type `c` and type `256M` . then `press` enter.<br/>
	d. Choose `A swap partition`.. then `press` enter.<br/>
	e. Type `c` and then press `enter`.<br/>
	f. Choose `A File System` , press `enter` and type `/`.<br/>
	g. Now, `root partition` and `swap partition` was created.<br/>

	press `q` to finish.

5. choose `1 CD/DVD`, then press `enter`, and press `enter` again to continue the installation. Please make sure back up all your data.
6. Processing installation
7. FreeBSD was installed, and then press enter.
8. Configure any Ethernet or SLIP/PP network devices choose `yes`
	
	a. choose `em0 Card` >> `enter` >> `IPV6 (no)` >> `DHCP no` ;<br/>
	b. and then configure network for your new FreeBSD Machine which u needed.<br/>
	c. press `enter` >> `em0 interface up right now (yes)` >> `as network gateway (no)` >>  `configure inetd and network services (no)` >> `SSH Login (yes)` >> `FTP anonymouse access (no)` >> `NFS server no` >> `NFS Client no` >> `customize console no` >> `set machine time zone yes` >> `UTC no` >> `choose as yourself` >> `Linux binary compability (yes)` >> `Mouse Integrated (no)` >> `browse colletion (no)` >> `user confirmation requested (yes)` >> choose `user` and fill as requested (`login id`, `password`, and `name`. also fill `wheel` on member groups for this member allowed login as super user >> press `enter` and exit >> `setup new password for root` >> `back to configuration menu (no)` >> select `exit Install` >> `Yes` .<br/>


9. Unchecked iso image FreeBSD on CDROMS Machine Settings and press `OK`, then boot that machine.


##Setting Network Virtual Box on Slackware Host

1. Active tun module

	`# modprobe tun`

2. create virtual card (`vbox0`) and give permission for user `deanet`.

	`# /opt/VirtualBox/VBoxTunctl -t vbox0 -u deanet`

3. Set ip address for Slackware Host: `192.168.1.1` and netmask `255.255.255.0`

	`# ip addr add 192.168.1.1/24 brd + dev vbox0`

4. up interface card

	`# iconfig vbox0 up`

check configuration
	
	# ip a

On network FreeBSD Virtual Box select card for `bridge` and `vbox0` . then boot again using new virtual card.

##NOTE:
####Please make sure you have authorized for device. It's means you can controlled virtual device on virtual box like usb,nic,cam,etc.

##tips:

To use slackware host as router just add value 1 on /proc/sys/net/ipv4/ip_forward

	echo "1" > /proc/sys/net/ipv4/ip_forward

Add nameserver on FreeBSD machine to look up domain from FreeBSD machine. :)

Reference:
1. [http://makassar-slackers.org/node/215](http://makassar-slackers.org/node/215)
2. [http://www.freebsd.org/doc/en/books/handbook](http://www.freebsd.org/doc/en/books/handbook)
