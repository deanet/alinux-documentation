--- 
layout: post
title: Install PHP-FPM pada Nginx 0.7.6 dari source
date: 2009-08-27 03:08:01
---

Setelah pada postingan <a href="/2009/08/21/install-nginx-0-7-61-dari-source.html" target="_new">sebelum nya</a>, menginstall nginx dari source. Pada kali ini kita akan mencoba install PHP-FPM. Mengapa PHP-FPM ??? atau PHP-FPM itu apa sih ?? . baca di <a href="http://interfacelab.com/nginx-php-fpm-apc-awesome/" target="_new">sini</a> untuk penjelasan lengkapnya.

oke lah. langkah pertama.

##Compile PHP:

##Donlot paket dan ekstrak

	# wget http://id.php.net/get/php-5.3.0.tar.gz/from/this/mirror
	# tar -xzvf php-5.3.0.tar.gz
	# wget http://php-fpm.org/downloads/php-5.3.0-fpm-0.5.12.diff.gz

Install patch untuk patching php.

	# zypper install patch

##Patching lalu configure

	# gzip -cd php-5.3.0-fpm-0.5.12.diff.gz | patch -d php-5.3.0 -p1
	# cd php-5.3.0/
	# ./configure --enable-fastcgi --enable-fpm --with-mcrypt --with-zlib --enable-mbstring --disable-pdo --with-curl --disable-debug --enable-pic --disable-rpath --enable-inline-optimization --with-bz2=/usr/local/sbin --with-xml --with-zlib --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --with-mhash --enable-xslt --enable-memcache --enable-zip --with-pcre-regex

`make`, `make test` lalu `make install`

	# make
	# make test
	# make all install

Setelah sukses make install jalankan perintah berikut:

	# /usr/local/src/php-5.3.0/build/shtool install -c ext/phar/phar.phar /usr/local/bin
	# ln -s -f /usr/local/bin/phar.phar /usr/local/bin/phar

Install module extention via `PECL`

	# pecl install memcache
	# pecl install apc
	# pecl install syck-beta

##Configuration PHP:

Kopi konfigurasi `php.ini-production` ke `/usr/local/lib/php.ini`

	# cd ../php-5.3.0/
	# cp php.ini-production /usr/local/lib/php.ini

Buat direktori untuk linking konfigurasi php

	# mkdir /etc/php/

linking `php.ini` dan `php-fpm.conf`

	# ln -s /usr/local/lib/php.ini /etc/php/php.ini
	# ln -s /usr/local/etc/php-fpm.conf /etc/php/php-fpm.conf

##Configurasi php-fpm.conf
	
	# vi /etc/php/php-fpm.conf

	<value name="owner">nobody</value>
	<value name="group">nobody</value>
	<value name="user">nobody</value>
	<value name="group">nobody</value>


##Config Nginx

linking direktori conf nginx ke `/etc`

	# ln -s /usr/local/nginx/conf /etc/nginx

konfigurasi file `nginx.conf`

	# vi /etc/nginx/nginx.conf

Ketik seperti ini


	{% highlight nginx %}
	user  nobody;
	worker_processes  6;
	events {
	    worker_connections  1024;
	}
	http {
	    include       mime.types;
	    default_type  application/octet-stream;
	    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
	                      '$status $body_bytes_sent "$http_referer" '
	                      '"$http_user_agent" "$http_x_forwarded_for"';
	    access_log  /var/log/nginx_access.log  main;
	    error_log	/var/log/nginx_error.log   debug;
	    sendfile        on;
	    keepalive_timeout  10 10;
	    gzip  on;
	    gzip_comp_level 1;
	    gzip_proxied any;
	    gzip_types text/plain text/css application/x-javascript text/xml
	application/xml application/xml+rss text/javascript;
	    server {
	        listen       80;
	        server_name  localhost;
	        location / {
	            root   html;
	            index  index.php index.html index.htm;
	        }
	        error_page   500 502 503 504  /50x.html;
	        location = /50x.html {
	            root   html;
	        }
	 	location ~ ^/index.php
	        {
	                fastcgi_pass 127.0.0.1:9000;
	                fastcgi_param SCRIPT_FILENAME
	//usr/local/nginx/html$fastcgi_script_name;
	                fastcgi_param PATH_INFO $fastcgi_script_name;
	                include /usr/local/nginx/conf/fastcgi_params;
	        }
	    }
	}
	{% endhighlight %}

	
##Konfigurasi file fastcgi_params

vi `/etc/nginx/fastcgi_params`

{% highlight nginx %}
fastcgi_param  QUERY_STRING       $query_string;
fastcgi_param  REQUEST_METHOD     $request_method;
fastcgi_param  CONTENT_TYPE       $content_type;
fastcgi_param  CONTENT_LENGTH     $content_length;
fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
fastcgi_param  REQUEST_URI        $request_uri;
fastcgi_param  DOCUMENT_URI       $document_uri;
fastcgi_param  DOCUMENT_ROOT      $document_root;
fastcgi_param  SERVER_PROTOCOL    $server_protocol;
fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;
fastcgi_param  REMOTE_ADDR        $remote_addr;
fastcgi_param  REMOTE_PORT        $remote_port;
fastcgi_param  SERVER_ADDR        $server_addr;
fastcgi_param  SERVER_PORT        $server_port;
fastcgi_param  SERVER_NAME        $server_name;
# PHP only, required if PHP was built with --enable-force-cgi-redirect
fastcgi_param  REDIRECT_STATUS    200;
fastcgi_connect_timeout 60;
fastcgi_send_timeout 180;
fastcgi_read_timeout 180;
fastcgi_buffer_size 128k;
fastcgi_buffers 4 256k;
fastcgi_busy_buffers_size 256k;
fastcgi_temp_file_write_size 256k;
fastcgi_intercept_errors on;
{% endhighlight %}

Bikin Script di `init.d` (RH based)

vi `/etc/init.d/nginx`

ketik seperti ini

{% highlight bash %}
#! /bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/local/nginx/sbin/nginx
NAME=nginx
DESC=nginx
PIDFILE=/usr/local/nginx/logs/$NAME.pid
DAEMON_CONFIG=/usr/local/nginx/conf/nginx.conf
    test -x $DAEMON || exit 0
    set -e
    case "$1" in
      start)
            echo -n "Starting $DESC: "
            start-stop-daemon --start --quiet --pidfile $PIDFILE \
                    --exec $DAEMON
            echo " started"
            ;;
      stop)
            echo -n "Stopping $DESC: "
     if [ -f $PIDFILE ]; then
                    kill -15 `cat $PIDFILE 2>/dev/null`
            fi
            echo " stopped"
            ;;
      restart|force-reload)
            echo -n "Restarting $DESC: "
     if [ -f $PIDFILE ]; then
                    kill -15 `cat $PIDFILE 2>/dev/null`
            fi
            sleep 1
            start-stop-daemon --start --quiet --pidfile $PIDFILE \
                    --exec $DAEMON
            echo " restarted"
            ;;
      status)
            echo "Status $DESC: "
            ps aux | grep -v grep | grep -v /bin/sh | grep $NAME
            ;;
      *)
            N=/etc/init.d/$NAME
            echo "Usage: $N {start|stop|status|restart}" >&2
            exit 1
            ;;
    esac
    exit 0
{% endhighlight %}


##Testing:

Jalankan `php-fpm`
	
	# /usr/local/sbin/php-fpm start

lihat apakah sudah running atau belum
	
	# netstat -tulpn | grep 9000

Jalankan script nginx
	
	# chmod a+x /etc/init.d/nginx
	# /etc/init.d/nginx start

lihat apakah sudah running atau belum

	# netstat -tulpn | grep 80

bikin file `index.php` di `/usr/local/nginx/html/` . isi dengan:

{% highlight php %}
	<?php phpinfo(); ?>
{% endhighlight %}

Akses ke localhost `127.0.0.1` atau sesuai alamat ip nya.


##Troubleshooting:

####A. ERROR PHP

####1. Masalah:
	
	configure: error: XML configuration could not be found

####Solusi:
	
	# zypper install libxml2-devel


####2. Masalah:

	checking for BZip2 in default path... not found
	configure: error: Please reinstall the BZip2 distribution

####Solusi:
Install `bzip2` dari source.
	
	# cd ..
	# wget http://www.bzip.org/1.0.5/bzip2-1.0.5.tar.gz
	# tar -xzvf bzip2-1.0.5.tar.gz
	# cd bzip2-1.0.5/
	# make
	# make install PREFIX=/usr/local/sbin/


####3. Masalah:

	checking for cURL in default path... not found
	configure: error: Please reinstall the libcurl distribution -
	easy.h should be in /include/curl/

####Solusi:
	
	zypper install libcurl-devel libmcrypt-devel mhash-devel

##B. MEMCACHE

#####1. Masalah:
	
	checking for re2c... no
	configure: WARNING: You will need re2c 0.13.4 or later if you want to regenerate PHP parsers.

#####Solusi:
	
	# zypper install re2c


#####2. Masalah:

	Configuring for:
	PHP Api Version:         20090626
	Zend Module Api No:      20090626
	Zend Extension Api No:   220090626
	Cannot find autoconf. Please check your autoconf installation and the
	$PHP_AUTOCONF environment variable. Then, rerun this script.
	ERROR: `phpize' failed</code>

####Solusi:
	
Install autoconf
	
	# zypper install autoconf

lalu jalankan lagi `pecl install memcache`

	Enable memcache session handler support? [yes] :y <== ketik y

####Hasil:
	Build process completed successfully
	Installing
	'/usr/local/lib/php/extensions/no-debug-non-zts-20090626/memcache.so'
	install ok: channel://pecl.php.net/memcache-2.2.5
	configuration option "php_ini" is not set to php.ini location
	You should add "extension=memcache.so" to php.ini</code>
	

##C. APC

####1. Masalah:
	
	Sorry, I was not able to successfully run APXS.  Possible reasons:
	1.  Perl is not installed;
	2.  Apache was not compiled with DSO support (--enable-module=so);
	3.  'apxs' is not in your path.  Try to use --with-apxs=/path/to/apxs
	The output of apxs follows
	/tmp/pear/temp/APC/configure: line 4061: apxs: command not found
	configure: error: Aborting
	ERROR: `/tmp/pear/temp/APC/configure --with-apxs' failed
	make: *** [php_apc.lo] Error 1</code>

####Solusi:
	
	# pecl install apc-beta
	Enable per request file info about files used from the APC cache [no] : n <== ketik n
	Enable spin locks (EXPERIMENTAL) [no] : n <== ketik n


####Hasil:
	
	Build process completed successfully
	Installing '/usr/local/lib/php/extensions/no-debug-non-zts-20090626/apc.so'
	install ok: channel://pecl.php.net/APC-3.1.3p1
	configuration option "php_ini" is not set to php.ini location
	You should add "extension=apc.so" to php.ini</code>
	

##D. SYCK

####1. Masalah:
	checking for syck files in default path... not found
	configure: error: Please reinstall the syck distribution
	ERROR: `/tmp/pear/temp/syck/configure' failed</code>

####Solusi:

Install `syck` dari source.

	# wget http://files.rubyforge.mmmultiworks.com/syck/syck-0.55.tar.gz
	# tar -xzvf syck-0.55.tar.gz
	# cd syck-0.55/
	# ./configure
	# make
	# make install

####Hasil:

	Build process completed successfully
	Installing '/usr/local/lib/php/extensions/no-debug-non-zts-20090626/syck.so'
	install ok: channel://pecl.php.net/syck-0.9.3
	configuration option "php_ini" is not set to php.ini location
	You should add "extension=syck.so" to php.ini</code>

Referensi:

1. [Nginx init](http://www.magnet-id.com/download/nginx/nginx-daemon)
2. [Main Tutorial](http://interfacelab.com/nginx-php-fpm-apc-awesome/)
3. [APC Error Bug](http://pecl.php.net/bugs/bug.php?id=16078)
4. [Syck Error Configuration reinstall](http://labs.uechoco.com/blog/2008/04/phppeclsyck.html)
5. [Autoconf](http://tunggul.staff.uns.ac.id/2009/01/09/howto-install-eaccelerator-di-freebsd/)
6. [XML error](http://webhostingneeds.com/Configure:_error:_XML_configuration_could_not_be_found)
