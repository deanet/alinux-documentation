--- 
layout: post
title: Build dan Install Kernel di FreeBSD 7.2 untuk PF, ALTQ, dan Quota Disk Management
date: 2009-11-07 07:11:09
---

Sudah lama tak bersua di sini. Sedikit dokumentasi dari saya. Mungkin ini tak berarti bagi anda, tapi mungkin berarti bagi org2 dibelahan bumi yang lain membutuhkan informasi ini. Baik langsung saja:

##Persiapan build dan install kernel:
  
	# cd /usr/src/sys/i386/conf
	# mkdir /root/kernels
	# cp GENERIC /root/kernels/MYKERNEL
	# ln -s /root/kernels/MYKERNEL

edit konfig kernel
	
	# vi MYKERNEL

##packet filter:

Untuk PF tambahkan di akhir baris `MYKERNEL` seperti berikut:
	
	device pf
	device pflog
	device pfsync


`ALTQ` atau alternate queuing of network packets. utility untuk `PF`

{% highlight bash %}
# Untuk ALTQ
options         ALTQ
options         ALTQ_CBQ        # Class Bases Queuing (CBQ)
options         ALTQ_RED        # Random Early Detection (RED)
options         ALTQ_RIO        # RED In/Out
options         ALTQ_HFSC       # Hierarchical Packet Scheduler (HFSC)
options         ALTQ_PRIQ       # Priority Queuing (PRIQ)
options         ALTQ_NOPCC      # Required for SMP build
{% endhighlight %}


##Untuk Disk QUota Manajemen

	options QUOTA

Lalu sekarang build dan install
	
	# cd /usr/src/
 	# make buildkernel KERNCONF=MYKERNEL
	# make installkernel KERNCONF=MYKERNEL

selesai...

konfig `rc` nya sekarang....

##Configurasi rc.conf

Untuk PF:

{% highlight bash %}
# untuk PF
pf_enable="YES";                 # Enable PF (load module if required)
pf_rules="/etc/pf.conf&quot;         # rules definition file for pf
pf_flags="";                     # additional flags for pfctl startup
pflog_enable="YES";              # start pflogd(8)
pflog_logfile="/var/log/pflog";  # where pflogd should store the logfile
pflog_flags="";
# jika pake LAN dibelakang firewall enable gatewaynya
gateway_enable="YES";
ipfilter_enable="YES";
ipnat_enable="YES";
ipmon_enable="YES";
ipfs_enable="YES";
{% endhighlight %}

Untuk Disk Quota:

{% highlight bash %}
# Disk Quota
enable_quotas=&quot;YES&quot;
check_quotas=&quot;NO&quot;
{% endhighlight %}

Configurasi `/etc/fstab` untuk Quota Disk:

contoh:

	/dev/ad0s1f             /usr            ufs     rw,userquota,groupquota        22


*reboot....*


##Cara Pake

##PF:

Enable:
	
	pfctl -e

Disable:

	pfctl -d

Add
 
	pfctl -t nama_tabel -T add no_ip

	[root@share /usr/home/admin]# pfctl -t tendang -T add 192.168.1.34
	1 table created.
	1/1 addresses added.

2 ip sekaligus

	[root@share /usr/home/admin]# pfctl -t tendang -T add 192.168.1.34 192.168.1.33 2/2 addresses added.


del
	pfctl -t nama_tabel -T delete no_ip

	[root@share /usr/home/admin]# pfctl -t tendang -T delete 192.168.1.34 192.168.1.33
2/2 addresses deleted.


##Disk quota

Aktifkan quota partisi:
	
	quotacheck /usr

jika belum ada quota manajemennya, maka akan membuat file `quota.user` dan `quota.group` di `/usr`

##Manajemen quota untuk user

misal: user `deanet`

	# edquota deanet
	Quotas for user deanet:
	/usr: kbytes in use: 16982, limits (soft = 17000, hard = 17500)
        inodes in use: 55, limits (soft = 0, hard = 0)

##Penjelasan:
soft=17000
hard=17500
alokasi tenggang (kbytes) = 500


save lalu cek:

	[root@share /usr/home/admin]# quota deanet
	Disk quotas for user deanet (uid 1001):
	     Filesystem   usage   quota   limit   grace   files   quota   limit   grace
	           /usr   16982   17000   17500              55       0       0

lalu skarang test copy file:

	[deanet@share ~]$ cp ../admin/Docs/debian-503-i386-netinst.iso .
	/usr: warning, user disk quota exceeded
	/usr: write failed, user disk limit reached
	cp: ./debian-503-i386-netinst.iso: Disc quota exceeded

cek lagi, apa benar quota disk uda jalan:

	[deanet@share ~]$ quota
	Disk quotas for user deanet (uid 1001):
	     Filesystem   usage   quota   limit   grace   files   quota   limit   grace
	           /usr   17446*  17000   17500   7days      56       0       0

okeh, it's work..


Referensi:
**lum ada, linkna lupa.. nyusul..**
