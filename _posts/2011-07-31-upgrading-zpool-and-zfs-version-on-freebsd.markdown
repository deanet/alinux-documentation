--- 
layout: post_new
title: Upgrading ZPOOL and ZFS version on FreeBSD
date: 2011-07-31 14:27:14
categories: 
- ZPOOL
- ZFS
- FreeBSD
---

After upgrade to current FreeBSD, i've got warning below:

{% highlight bash %}
mars# zpool status
  pool: zroot
 state: ONLINE
status: The pool is formatted using an older on-disk format.  The pool can
	still be used, but some features are unavailable.
action: Upgrade the pool using 'zpool upgrade'.  Once this is done, the
	pool will no longer be accessible on older software versions.
 scan: none requested
config:

	NAME           STATE     READ WRITE CKSUM
	zroot          ONLINE       0     0     0
	  mirror-0     ONLINE       0     0     0
	    gpt/disk0  ONLINE       0     0     0
	    gpt/disk1  ONLINE       0     0     0

errors: No known data errors
{% endhighlight %}


so we need upgrade it.

{% highlight bash %}
mars# zpool upgrade -a
This system is currently running ZFS pool version 28.

Successfully upgraded 'zroot'

If you boot from pool 'zroot', don't forget to update boot code.
Assuming you use GPT partitioning and da0 is your boot disk
the following command will do it:

	gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 da0
{% endhighlight %}

upgrade also boot partition. make sure disk is true.

{% highlight bash %}
$ sysctl -a | grep disk
kern.disks: ada1 ada0
kern.geom.disk.ada0.led: 
kern.geom.disk.ada1.led: 
2 LABEL gpt/disk1 151451851264 512 i 0 o 0
2 LABEL gpt/disk0 151451851264 512 i 0 o 0
z0xfffffe0002deb500 [shape=box,label="DEV\ngpt/disk1\nr#4"];
z0xfffffe0002deb300 [shape=box,label="DEV\ngpt/disk0\nr#4"];
z0xfffffe0002da8600 [shape=hexagon,label="gpt/disk1\nr1w1e1\nerr#0"];
z0xfffffe0002ac2200 [shape=hexagon,label="gpt/disk0\nr1w1e1\nerr#0"];
      <name>gpt/disk1</name>
      <name>gpt/disk0</name>
	    <label>disk1</label>
	    <label>disk0</label>
	  <name>gpt/disk1</name>
	  <name>gpt/disk0</name>
vfs.nfs.diskless_rootpath: 
vfs.nfs.diskless_valid: 0
"ATA state lock","g_disk_done"
"g_disk_done","UMA zone"
"g_disk_done","bio queue"
$ 
{% endhighlight %}

run once again.

{% highlight bash %}

mars# gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 ada0
bootcode written to ada0
mars# gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 ada1
bootcode written to ada1
{% endhighlight %}


run upgrade once again.

{% highlight bash %}

mars# zfs upgrade -a
17 filesystems upgraded

mars# zpool upgrade
This system is currently running ZFS pool version 28.

All pools are formatted using this version.
mars# zfs upgrade
This system is currently running ZFS filesystem version 5.

All filesystems are formatted with the current version.
mars# exit
exit

mars# reboot 
{% endhighlight %}

dont forget to reboot.

ref:

[http://tyuu.com/wordpress/?paged=3](http://tyuu.com/wordpress/?paged=3)

