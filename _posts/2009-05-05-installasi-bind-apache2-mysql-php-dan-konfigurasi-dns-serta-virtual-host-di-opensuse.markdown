--- 
layout: post
title: Installasi BIND, Apache2, Mysql, PHP dan Konfigurasi DNS serta Virtual Host di OpenSuse
date: 2009-05-05 05:05:12
---

## BIND - DNS Server
cek bind nya sudah ada apa belum:

	#rpm -qa|grep bind

jika bind na lum ada ketik:

	#yast2 -i bind

### Konfigurasi DNS:

pastikan `/etc/resolv.conf` terisi ip dari `nameserver` km. misal

	nameserver xxx.99.198.183

selanjutnya tambahkan pada file `/etc/named.conf` seperti berikut:

	zone "domain.com" IN {
        type master;
        file "/var/lib/named/domain.com.zone";
        allow-update {none;};
	};
	zone "198.99.198.183.in-addr.arpa" IN {
        type master;
        file "/var/lib/named/198.99.xxx.rev";
        allow-update {none;};
	};


buat file domain.com.zone di `/var/lib/named` yang isinya:


	@       IN      SOA     ns1.domain.com. domain.com (
                        200903203
                        10800
                        3600
                        604800
                        3600 ) ;

        IN     NS      ns1.domain.com.
        IN     NS      ns2.domain.com.
        IN      A       xxx.99.198.183
	ns1   IN      A       xxx.99.198.183
	ns2   IN      A       xxx.99.198.183
	www IN      A       xxx.99.198.183


selanjutnya file `198.99.xxx.rev` di folder `/var/lib/named` yang isinya:


	$TTL    14400
	@       86400   IN      SOA     ns1.domain.com. domain.com (
                2009021501
                86400
                7200
                3600000
                86400 );
	IN NS ns1.domain.com
	1 IN PTR ns1.domain.com
	2 IN PTR www.domain.com

	$TTL    1440
	@       86400   IN      SOA     ns2.domain.com. domain.com (
                2010021501
                86400
                7200
                3600000
                86400 );
	IN      NS              ns2.domain.com
	1       IN      PTR     ns2.domain.com
	2       IN      PTR     www.domain.com


oke, untuk dns sudah. 2 file `zone` dan `reverse` adalah file yang paling penting. Untuk mengetest apakah sudah benar apa belum konfigurasinya bsa menggunakan nslookup ato dig. eitsss.. pastikan daemon bind na uda jalan.

###cek status daemon dns server:

	#rcnamed status

untuk menjalankan ketik:

	#rcnamed start

untuk test dns domain `domain.com` :

	#dig domain.com

	; <<>> DiG 9.4.2-P1 <<>> domain.com
	;; global options:  printcmd
	;; Got answer:
	;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 41519
	;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 2
	;; QUESTION SECTION:
	;domain.com.                 IN      A
	;; ANSWER SECTION:
	domain.com.          3600    IN      A       xxx.99.198.183
	;; AUTHORITY SECTION:
	domain.com.          3600    IN      NS      ns2.domain.com.
	domain.com.          3600    IN      NS      ns1.domain.com.
	;; ADDITIONAL SECTION:
	ns1.domain.com.      3600    IN      A       xxx.99.198.183
	ns2.domain.com.      3600    IN      A       xxx.99.198.183
	;; Query time: 1 msec
	;; SERVER: xxx.99.198.183#53(xxx.99.198.183)
	;; WHEN: Tue May  5 14:01:58 2009
	;; MSG SIZE  rcvd: 115


ato dg `nslookup`

	nslookup
	> set type=all
	> domain.com
	Server:  ns1.dtp.net.id
	Address:  xxx.43.160.50
	Non-authoritative answer:
	domain.com   internet address = xxx.99.198.183
	domain.com
        primary name server = ns1.domain.com
        serial  = 200903203
        refresh = 10800 (3 hours)
        retry   = 3600 (1 hour)
        expire  = 604800 (7 days)
        default TTL = 3600 (1 hour)
	domain.com   nameserver = ns1.domain.com
	domain.com   nameserver = ns2.domain.com
	domain.com   nameserver = ns2.domain.com
	domain.com   nameserver = ns1.domain.com
	domain.com   internet address = xxx.99.198.183

okeh... jika uda ada result berarti uda bs jalan. klo eror y dicoba maning, n itu baru dns nya ajah :D, lum install apache. setting vhostna dll.

##Apache

###Installasi apache:

	#yast -i apache2

lihat status apache uda jalan lum:

	#rcapache2 status

klo belum jalankan:

	#rcapache2 start

###Installasi PHP

	#yast -i php5 php5-mysql apache2-mod_php5

untuk lihat modul apache yang sudah jalan apa aj ketik:

	#a2enmod -l

jika lum ada php5 yang terload ketik:

	#a2enmod php5

lalu restart modul apache na:

	#rcapache2 restart

bisa di test dengan skrip php

##MySQL:

untuk installasi ketik:

	#yast -i mysql

lalu jalankan daemon mysql

	#rcmysql start

ganti password mysql

	#mysqladmin -u root -p passwordbaru


okeh, sampe saat ini sudah ada apache,mysql,php ama dns serper. untuk ngecek apakah daemonna jalan, scan aj pake nmap.

	#nmap localhost
	Starting Nmap 4.60 ( http://nmap.org ) at 2009-05-05 14:30 UTC
	Warning: Hostname localhost resolves to 2 IPs. Using 127.0.0.1.
	Interesting ports on localhost.localdomain (127.0.0.1):
	Not shown: 1705 closed ports
	PORT     STATE SERVICE
	21/tcp   open  ftp
	53/tcp   open  domain
	80/tcp   open  http
	3306/tcp open  mysql
	Nmap done: 1 IP address (1 host up) scanned in 0.495 seconds

klo nmap belum ada install dolo lah :D . pake yast -i nmap

##Virtual Host
nah, akhirnya sampek jugak ke virtual host. ni yang bkin puyeng cos ngutek2 dari pagi sampek sore ndak isa2. weleh2. ternyata naruh nya salah. okeh.

###Kasus:
Virtual Host yang aq pake sekarang adalah untuk bkin 2 subdomain dan 1 root domain.

###Pemecahan:
hanya dibutuhkan 1 file `zone` dan 1 file `reverse`. Jadi setiap subdomain ditambahkan dalam `zone` root domain, tidak berdiri dalam file sndiri. bisa sih berdiri diri sendiri, tapi agak rumit or gimna kata [org](http://wowtutorial.org) yang mengajariku :D . bagaimna jika ada root domain lain ?? jawabnnya maka baru dibuat 1 file `zone` lagi.

oke, daripada ngomong ngalor ngidul gak karuan. skrg ke `POC` na aj:

tambahkan pada file `/var/lib/named/198.99.208.rev` seperti berikut

	$TTL 86400
	@       IN      SOA     sub1.domain.com.   sub1.domain.com (
                        100
                        1H
                        1M
                        1W
                        1D );
	@       IN      NS      ns1.domain.com
	@       IN      NS      ns2.domain.com

	$TTL 86400
	@       IN      SOA     sub2.domain.com.   sub2.domain.com (
                        100
                        1H
                        1M
                        1W
                        1D );
	@       IN      NS      ns1.domain.com
	@       IN      NS      ns2.domain.com

terus pada file `domain.com.zone` tambahkan:

	sub1  IN      A       xxx.99.198.183
	sub2  IN      A       xxx.99.198.183

selesai :mrgreen: . mudahkan ... heheheeh .. cmn nambahin d `reverse` na sama 2 baris seuprit di `zone` na ...

eitssss... skrg kita konfig virtual hostna
di open suse, file `/etc/apache2/httpd.conf` nya menginclude file `default-server.conf`. di file `default-server.conf` , konfigruasi root directory di set di situ. untuk vhost na di set di `conf.d/*.conf` yang terinisialisasi di file `httpd.conf` na. jadi disable aj di `httpd.conf` pada bagian:

	#Include /etc/apache2/vhosts.d/*.conf

selanjutnya kita akan mengkonfigurasi langsung di file `default-server.conf`. so gak perlu repot2 buka2 file. ckup satu file aj :) . Yang perlu diperhatikan adalah ketika menmbhkan vhost utk subdomain, maka root domain juga mesti ditambahkan. oke. kira2 konfigna sperti ini:

	{% highlight ApacheConf %}
	NameVirtualHost xxx.99.198.183:80
	<virtualHost domain.com:80>
        	ServerName domain.com
	        ServerAlias www.domain.com
	        DocumentRoot "/srv/www/htdocs"
        	CustomLog "/var/log/apache2/domain.access.log" combined
	        ErrorLog "/var/log/apache2/domain.error.log"
	        HostnameLookups Off
	        UseCanonicalName Off
	        ServerSignature Off
	        <directory "/srv/www/htdocs">
                Options All
                AllowOverride None
                Order allow,deny
                Allow from all
        	</directory>
	</virtualHost>
	<virtualHost sub1.domain.com:80>
	        ServerName sub1.domain.com
	        ServerAlias www.sub1.domain.com
	        DocumentRoot "/home/deanet/www/sub1.domain.com"
	        CustomLog "/var/log/apache2/sub1.access.log" combined
	        ErrorLog "/var/log/apache2/sub1.erorr.log"
	        HostnameLookups Off
	        UseCanonicalName Off
	        ServerSignature Off
       		<directory "/home/deanet/www/debiku.domain.com">
                Options All
                AllowOverride None
                Order allow,deny
                Allow from all
        </directory>
	</virtualHost>
	<virtualHost sub2.domain.com:80>
        ServerName sub2.domain.com
        ServerAlias www.sub2.domain.com
        DocumentRoot "/home/deanet/www/sub2.domain.com"
        CustomLog "/var/log/apache2/sub2.access-log" combined
        ErrorLog "/var/log/apache2/sub2.error.log"
        HostnameLookups Off
        UseCanonicalname Off
        ServerSignature Off
        <directory "/home/deanet/www/sub2.domain.com">
                Options All
                AllowOverride None
                Order allow,deny
                Allow from All
        </directory>
	</virtualHost>
	{% endhighlight %}

kalo uda mantep restart apache na :)

jangan lupa pastikan konfigruasi file `/etc/hosts` ditambahkan :

	xxx.99.198.183  sub1.domain.com sub2.domain.com domain.com

restart networkna:

	#rcnetwork restart

n pastikan kondisi nameserver pada file `/etc/apache2/listen.conf` keadaaan uncomment

	#NameVirtualHost *:80


lalu coba akses ke domain, subdomainnya juga. Jika masih gagal terus... yaaa .. dicoba kembali .. sampek bisa.

huff... akhirna slesai jugakk, never stop to learn n try .... gud lak... ;)

cmiiw

referensi:

1. [susegeek.com](http://www.susegeek.com/internet-browser/install-configure-lamp-apachemysqlphp-in-opensuse-110/)
2. [www.xenocafe.com](http://www.xenocafe.com/tutorials/dns_linux/redhat/dns_linux_redhat-part1.php)
3. [www.devhood.com](http://www.devhood.com/tutorials/tutorial_details.aspx?tutorial_id=731)
4. [content.websitegear.com](http://content.websitegear.com/article/domain_setup.htm)
5. [httpd.apache.org](http://httpd.apache.org/docs/2.0/vhosts/examples.html)
