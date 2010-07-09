--- 
layout: post
title: Cara membuat system FreeBSD 7.2 / 8.0 release ke stable pasca installasi
date: 2010-04-23 23:00:04
---

Jika pada <a href="/2009/10/01/installation-and-setting-network-freebsd-virtual-box-on-slackware-host.html" target="_new">postingan sebelumnya</a> kita memasang / installasi FreeBSD. Maka pada kesempatan kali ini saya akan berbagi mengenai membuat system FreeBSD stable setelah atau pasca installasi. Tutorial ini sebenernya sudah komplit dijelaskan <a href="http://forum.linux.or.id/viewtopic.php?f=44&amp;t=15429#p94372" target="_new">temen-temen forum.linux.or.id </a>. Namun ada sedikit perbedaan dengan yang saya jalanin dengan tutorial di forum. Selain itu saya juga ingin cara dengan cara yang saya lakukan sendiri.

Untuk installasinya bisa dilihat pada <a href="/2009/10/01/installation-and-setting-network-freebsd-virtual-box-on-slackware-host.html" target="_new">postingan sebelumnya</a>. Setelah installasi sukses sekarang kita coba inti judul post ini. oiya kita menggunakan `cvsup` untuk update `port`. `Port` itu semacam `/var/cache/apt/archive` kalo d debian base.

##1. Install cvsup dan utiliti cvsup

	# cd /usr/ports/net/cvsup-without-gui; make install clean
	# cd /usr/ports/sysutils/fastest_cvsup; make install clean


##2. lalu jalankan command dibawah untuk mencari server yang tercepat

	# fastest_cvsup -c sg,tw,jp

##3. setelah didapatkan server yang tercepat, masukan ke dalam port-sup file ( `/usr/share/examples/cvsup/ports-supfile` ). Jangan lupa baca2 dulu keterangan didalam file tersebut dan bikin salinannnya.

	# cp /usr/share/examples/cvsup/ports-supfile /root/

contoh file `ports-supfile` (hanya port saja). maksudnya jika system kita ndak ingin update ke stable. jadi cuman update portnya aj. kenapa diupdate ? karena kemungkinan ada bug dalam distribusi paket binarynya mungkin. jadi ketika kita ingin install port, kita sudah mempunyai list port yang baru. bukan yang lama.

{% highlight bash %}
*default host=cvsup10.tw.freebsd.org
*default base=/var/db
*default prefix=/usr
*default release=cvs tag=.
*default delete use-rel-suffix
*default compress
ports-all
{% endhighlight %}

nah yang ini utk source:

{% highlight bash %}
*default host=cvsup10.tw.freebsd.org
*default base=/var/db
*default prefix=/usr
*default release=cvs tag=RELENG_8
*default delete use-rel-suffix
*default compress
src-all
{% endhighlight %}

##4. terus jalankan cvsup na dengan perintah

	# cvsup /root/ports-supfile


##5. kita sante dulu, tinggal makan atau beli gorengan ...  sekalian pesen intel... :mrgreen: , tinggal nge-game juga bobol.. boleh boleh aj... :lol:

##6. terus kita update ke stable dengan kompail kernel

	# cd /usr/src/
	# make buildworld
	# make buildkernel kernconf=CONF
	# make installkernel kernconf=CONF
	# make installworld
	# mergemaster

tinggal makan aj dulu... sambil tiduran... terus reboot dah.. dan silahkan bandingkan release dengan perintah uname -r atau uname -a

##Tips:

Jika update port melalui `cvsup` gagal.. bisa dengan menggunakan portsnap. Jika belum pernah update menggunakan portsnap jalankan:

	# portsnap fetch

jika sudah pernah jalankan

	# portsnap fetch update

lalu ekstrak:

	# portsnap extract

terus balik lagi dah ke `make buildworld` ;)

referensi:
1. [forum.linux.or.id](http://forum.linux.or.id/viewtopic.php?f=44&amp;t=15429#p94372)
2. [mail-archive.com](http://www.mail-archive.com/freebsd-questions@freebsd.org/msg101371.html)
