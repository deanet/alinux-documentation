--- 
layout: post
title: Installasi FreeBSD dan setting jaringan FreeBSD as guest di vmware server
date: 2009-06-12 12:00:00
---

##FreeBSD ....
hmm... sudah lama sekali skitar satu tahun yang lalu pgen nyobain FreeBSD tapi lum kesampean2. Dulu pertama kali denger rasanya aneh. lagian ada juga teman2 nya seperti NetBSD terus lagi OpenBSD. Waduh.. makanan apalagi tuh. Kalau ga salah pertama kali dengar sistem operasi ini pas semester 5-6 lah. Macam kayak kutu kupret aq g tahu makanan kek gini (sampek skrg :mrgreen:) . Alhasil, setelah baca2 waktu itu akrhirnya tau juga kalo FreeBSD,OpenBSD, sama NetBSD adalah satu keturunan dari BSD. BSD sendiri kepanjangan dari Bumi Serpong Damai ... eh g dink :D . klo km cari di wikipedia emang ada 2 :mrgreen: . BSD ituh kepanjangan dari barkeley software distribution. Tadi smpet lupa SD nya kepanjangan dari apa. Kalo B nya itu memang dari sebuah kota Barkeley sono, kampus barkeley. *back to topic*.

Barkeley itu dikembangkan untuk sistem unix AT&amp;T. (doh) pa lagi tuh AT&amp;T sama unix ? . mending baca selengkapnya <a href="http://id.wikipedia.org/wiki/Berkeley_Software_Distribution" target="_new">di sini</a>. Nah BSD ini punya anak 3 dan anak2 yg lainnya, FreeBSD terus NetBSD sama OpenBSD, dll. semua lahir karena punya karakteristik sendiri2. Biasalah namanya juga kreativitas ;) .

Ok, Installasi FreeBSD sebenernya gampang-gampang susah. Gampang kalo pas lancar, n susah kalo pas g lancar. hehe. Ya intinya jangan pernah menyerah lah. ok, aq install FreeBSD ini di mesin virtual <a href="http://vmware.com" target="_new">vmware</a>, km bisa coba ke mesin asli.

##Installasi FreeBSD:

1. Donlot dulu isonya di <a href="http://www.freebsd.org" target="_new">freebsd.org</a>
2. Boot iso nya, terus liat langkah selanjutnya di <a href="http://www.freebsd.org/doc/en/books/handbook/install-start.html" target="_new">sini</a> :D

Di situ uda komplit banget panduannya, tinggal merhatiin apa2 aj yg mesti dilakukan. Yang kudu diperhatiin:
1. FreeBSD mesti pake partisi primary.
2. Setiap partisi diistilahkan sebagai slice (cmiiw)

Itu aja sih. perintah-perintah bikin slice sudah lengkap di <a href="http://www.freebsd.org/doc/en/books/handbook/install-start.html">situ</a> . seperti `n` untuk bikin slice baru, `d` untuk hapus slice, baca deh manualnya :). Jangan lupa install openssh dan aktifkan daemonnya biar waktu boot langsung diaktifkan service na. Terus bikin user baru juga.

Nah, kalo uda ke install dengan baik, coba kita setting biar FreeBSD na bisa nge-ping jaringan kita, terus konek internet supaya bisa install httpd php mysql dengan mudah via `ports` (posting selanjutnya).

####1. setting network FreeBSD di vmware na pake bridge

####2. lalu boot, dan Login via root di vmware
####3. Ketik ifconfig untuk liat nama interface na

ketik `ifconfig` untuk liat nama interface nya

	FreeBSD# ifconfig
	le0: flags=8843<up,BROADCAST,RUNNING,SIMPLEX,MULTICAST> metric 0 mtu 1500
        options=8<vlan_MTU>
        ether 00:0c:29:82:21:3e
        inet 10.100.100.22 netmask 0xffffff00 broadcast 10.100.100.255
        media: Ethernet autoselect
        status: active
	plip0: flags=108810<pointopoint,SIMPLEX,MULTICAST,NEEDSGIANT> metric 0 mtu 1500
	lo0: flags=8049<up,LOOPBACK,RUNNING,MULTICAST> metric 0 mtu 16384
        inet6 fe80::1%lo0 prefixlen 64 scopeid 0x3
        inet6 ::1 prefixlen 128
        inet 127.0.0.1 netmask 0xff000000

Disitu terlihat nama interface yang dipake adalah `le0` . dan juga sudah ada ip nya karena memang sudah diseting, kalo belum pasti belum keliatan.

####4. Tambahkan opsi di `/etc/rc.conf`

	ifconfig_le0="inet 10.100.100.22 netmask 255.255.255.0"

`ifconfig_le0` = `le0` sesuai dengan nama interface na
`10.100.100.22` = ini ip yang masih nganggur di jaringan kmputer kita (bukan virtual/host).
`255.255.255.0` = netmask yang kita pake di jaringan kmputer kita (bukan virtual/host).

nah kalo sudah restart jaringannya dengan ketik:

	/etc/rc.d/netif restart

lalu coba ping ke alamat ip komputer kita (host). misal ip yang aq pake di host adalah 10.100.100.23. harusnya smpai sini kita sudah bisa ngeping alamat ip host. kalo gak bisa coba restart dolo guest/ FreeBSD na. :D .

.. uda bos, tapi Lho... koq g bisa ngeping google ?? hehe .. tenang dulu bos, kita mesti nambahin gateway sama name server /dns nya.

####5. Tambahkan name server

tambahkan dns / domain name server di `/etc/resolv.conf`

	nameserver xxx.xxx.3.7
	nameserver xxx.xxx.3.6

####6. Tambahkan gateway dan hostname di `/etc/rc.conf`

	defaultrouter="10.100.100.1"
	hostname="FreeBSD.mesinvirtual.com"

####7. Tambahkan alias host di `/etc/hosts`

	10.100.100.22           FreeBSD.mesinvirtual.com

coba reboot guestna, dan ping ke gogel. :)

####Experiment laen:

FreeBSD ni agak aneh. waktu pertama kali habis di-install su untuk user biasa digagalkan. Terus ssh untuk root juga di disable. so, kita mesti config sedikit biar enak nanti.

enable su untuk user biasa:
1. login ke root via vmware
2. ketik sperti berikut untuk menambahkan user baru ke group `wheel`

	{% highlight xml %}
	#pw groupmod wheel -M user_baru
	{% endhighlight %}

untuk liat apa sudah masuk ke group `wheel` ketik:
	
	# pw groupshow wheel
	wheel:*:0:root,user_baru

ok, coba akses ssh via putty ke mesin guest :D .. mantap bukan :mrgreen: .. mklum nih masi cupu :-P


Referensi:

1. [Official freebsd book](http://www.freebsd.org/doc/en/books/handbook/install-start.html)
2. [Panduan resmi setting Network](http://www.freebsd.org/doc/en/books/handbook/config-network-setup.html)
3. [Manual groupadd](http://www.freebsd.org/doc/en/books/handbook/users-groups.html)
4. [osdir.com](http://osdir.com/ml/freebsd.newbies/2004-12/msg00119.html)
5. [communities.vmware.com](http://communities.vmware.com/thread/20779)
