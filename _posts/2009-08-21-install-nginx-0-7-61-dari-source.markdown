--- 
layout: post
title: Install Nginx 0.7.61 dari source
date: 2009-08-21 21:00:08
---

Nginx. opo sih kui ?? yo koyo apache lah, kui kancane wes ngunu ae. :-P .. Nginx, web server ketok e. As embuh. Wes langsung install ae.

Pada percobaan kali ini dari source, bukan dari paket distribusi distro masing2.

##Persiapan:

install `make` `gcc` `openssl-devel` `pcre-devel` `zlib-devel` dulu.

pada mesin yang berbasis `RH`:

	zypper install make gcc openssl-devel pcre-devel zlib-devel


Mesin `debian` tinggal `apt-get` aj :mrgreen: . yang paling penting adalah saat konfigurasinya. okeh, sekarang kita konfig terus make lalu install.

donlot paket nginx n ekstrak

	# wget http://sysoev.ru/nginx/nginx-0.7.61.tar.gz
	# tar -xzvf nginx-0.7.61.tar.gz
	# cd nginx-0.7.61/


##Configurasi:

Pada mesin `Debian` base:

	./configure \
	--conf-path=/etc/nginx/nginx.conf \
	--error-log-path=/var/log/nginx/error.log \
	--pid-path=/var/run/nginx.pid \
	--lock-path=/var/lock/nginx.lock \
	--http-log-path=/var/log/nginx/access.log \
	--with-http_dav_module \
	--http-client-body-temp-path=/var/lib/nginx/body \
	--with-http_ssl_module \
	--http-proxy-temp-path=/var/lib/nginx/proxy \
	--with-http_stub_status_module \
	--http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
	--with-debug \
	--with-http_flv_module

Pada mesin `RH` base:

	./configure \
	--prefix=/usr \
	--sbin-path=/usr/sbin/nginx \
	--conf-path=/etc/nginx/nginx.conf \
	--error-log-path=/var/log/nginx/error.log \
	--pid-path=/var/run/nginx/nginx.pid  \
	--lock-path=/var/lock/nginx.lock \
	--user=nginx \
	--group=nginx \
	--with-http_ssl_module \
	--with-http_flv_module \
	--with-http_gzip_static_module \
	--http-log-path=/var/log/nginx/access.log \
	--http-client-body-temp-path=/var/tmp/nginx/client/ \
	--http-proxy-temp-path=/var/tmp/nginx/proxy/ \
	--http-fastcgi-temp-path=/var/tmp/nginx/fcgi/

Pada mesin saya cukup ketik `./configure` aja udah jalan. yes .. (dance_banana) . dan akan muncul seperti berikut diakhir baris configure

	Configuration summary
	+ using system PCRE library
	+ OpenSSL library is not used
	+ md5: using system crypto library
	+ sha1 library is not used
	+ using system zlib library
	nginx path prefix: "/usr/local/nginx"
	nginx binary file: "/usr/local/nginx/sbin/nginx"
	nginx configuration prefix: "/usr/local/nginx/conf"
	nginx configuration file: "/usr/local/nginx/conf/nginx.conf"
	nginx pid file: "/usr/local/nginx/logs/nginx.pid"
	nginx error log file: "/usr/local/nginx/logs/error.log"
	nginx http access log file: "/usr/local/nginx/logs/access.log"
	nginx http client request body temporary files: "client_body_temp"
	nginx http proxy temporary files: "proxy_temp"
	nginx http fastcgi temporary files: "fastcgi_temp"</code>
	
Jika sudah muncul keterangan configruation systemnya. maka berdoalah supaya saat `make` nya tidak gagal. :D

ketik Make:

	# make

lalu `install` deh

	# make install


##configurasi nginx

	# vi /usr/local/nginx/conf/nginx.conf

hilangkan komentar `;` pada depan kata user:

	user  nobody;

bikin direktori untuk temporary

	# mkdir /var/tmp/nginx

jalankan `nginx`:

	/usr/local/nginx/sbin/nginx

Untuk menghentikan nginx cukup ketik:

	killall -9 /usr/local/nginx/sbin/nginx

Lihat perubahan yang terjadi pada port dengan mengetikkan:

	netstat -ntlp

Akses ke `localhost` atau `127.0.0.1`, cukup sekian dan matur nuwun. :)



Referensi:
1. [Nginx Install Options](http://wiki.nginx.org/NginxInstallOptions)
