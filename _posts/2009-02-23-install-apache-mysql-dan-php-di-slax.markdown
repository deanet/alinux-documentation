--- 
layout: post
title: Install apache, mysql dan php di slax
date: 2009-02-23 23:00:00
---
Peralatan yang dibutuhkan:

`pkgtool`

biasanya `pkgtool` udah include di distro slax

bahannya:

Download di [sini](http://repository.slacky.eu/slackware-12.1/) (httpd,mysql,php)
Di sini menggunakan paket `httpd-2.2.8`, `php-5.2.5-i486` dan `mysql-5.0.51b` dari slacky. Semuanya paket `tgz`. Kenapa enggak pake paket `lzm` ?? karena kalo kita pake `lzm` ntar remove nya susah, so kita pake paket `tgz` biar ntar remove paket nya lebih mudah :) . Untuk installasi nya cukup mudah. Buka konsole, lalu masuk k direktori anda menyimpan paket2nya.
lalu ketik:

{% highlight bash %}
installpkg *.tgz
{% endhighlight %}


## Running apache

Untuk menjalankan apache na tinggal ketik

	/etc/rc.d/rc.httpd start

pastikan `rc.httpd` sudah diberi `bit x`.


## Enable PHP
Untuk enable php tambahkan modul di `/etc/httpd/httpd.conf`.
	vim /etc/httpd/httpd.conf

format penambahan modul:
	LoadModule foo_module modules/mod_foo.so

jadi komplitnya
	LoadModule php5_module lib/httpd/modules/libphp5.so


Terus tambahkan tipe mime nya
	AddType application/x-httpd-php .php


ato lebih mudah, bisa juga dengan uncomment pada baris yang ada di `/etc/httpd/httpd.conf` .
	vim /etc/httpd/httpd.conf


setelah masuk vim ketik:
	/mod.php.conf


akan ketemu baris seperti ini
	# Include /etc/httpd/mod_php.conf

hilangkan tanda `#` dengan tombol del

## testing

Buat script php sederhana

{% highlight php %}
<?php echo "test"; ?>
{% endhighlight %}

simpan dengan nama `test.php` misalnya di direktori `/var/www/htdocs/`

Pastikan daemon httpd / apache sudah jalan. ketik `localhost/test.php` pada browser


## MySQL

Ketika kita install MySQL sebenernya belum ada databasenya sama sekali. Karena itu kita mesti bikin sendiri.
	su mysql
	mysql_install_db

untuk menjalankan daemon mysql beri `bit x` ke `/etc/rc.d/rc.mysql` lalu ketik:

	/etc/rc.d/rc.mysql start

jika ada error
	ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysql/mysql.sock' (2)


solusi:
	chown -R mysql:mysql /var/lib/mysql/mysql
	chmod -R 755 /var/lib/mysql/mysql


kalo ada pertanyaan monggo .. kita sama2 belajar :)

gudlak ;)

Referensi:

1. `forum [dot] linux [dot] or [dot] id`
