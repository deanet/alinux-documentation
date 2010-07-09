--- 
layout: post
title: Installasi Postfix, Saslauthd, VM-Pop3d, dan SquirrelMail di OpenSuse
date: 2009-05-19 19:00:05
---
Tutorial ini khusus diperuntukkan bagi seorang pemula / nubie yang ingin belajar lebih dalam mengenai segala tetek bengek sper. So, tutorial ini bagus banget utk saya pribadi :D . Tidak diperuntukkan bagi anda2 yang sudah mahir, hapal, diluar kepala (sampek lupa *just kidding*), jago, super jago tentang segala srper.:D

okay, apa itu postfix? saslauthd ? vm-pop3d, n squirrelmail ??

##Pendahuluan:
Pernah kah terbayangkan ? gimna sih cara kerja ketika kita mengirim email dari login sampai logout ?. Bagaimna lagi kalau kita memakai email client like thunderbird or outlook ?? Hmmm ... Okay, proses tersebut paling tidak dibutuhkan :

###Mail Server
Mail Server yaitu sebuah server yang digunakan untuk menyimpan dan mengirim sebuah email. bisa diibaratkan mail server itu seperti sebuah kantor pos. Untuk mengirim sebuah email dari alamat email yang satu ke alamat email yang lain digunakan sebauh protocol (aturan) yaitu Simple Mail Transfer Protocol SMTP. Protocol SMTP telah menjadi aturan dasar yang disepakati untuk pengiriman email. Dengan demikian semua software email server pasti mendukung protokol ini.  SMTP merupakan protokol yang digunakan untuk megirim email (komunikasi antar mail server), dan tidak digunakan untuk berkomunikasi dengan client. Sedangkan untuk client, digunakan protokol imap imaps pop3 pop3s.

Contoh Mail Server:
- Postfix
- QMail
- Exim
- Sendmail
- dll

###IMAP / POP3
Supaya sebuah mail server dapat di akses oleh client, dikembangkan sebuah aplikasi dimana client dapat mengakses email dari sebuah email server. <a href="http://imap.org/" target="_new">IMAP</a> adalah sebuah aplikasi pada layer Internet protokol yang memungkinkan client untuk mengakses email yang ada di server. Selain IMAP ada juga POP3 yang fungsinya sama dengan imap, akan tetapi memiliki karakteristik yang berbeda dalam cara pengaksesan pada server.

<a href="http://imap.org/" target="_new">IMAP</a>
IMAP (Internet Message Access Protocol), protokol yang memperbolehkan pengambilan email tanpa harus didownload ke email client. Contoh penggunaan IMAP yang paling sering adalah akses web mail.

Menurut saya pribadi: imap itu digunakan sebagai interface antara client dan server berbasis webmail. Ada banyak macam Imap server, like :
- UW IMAP
- Dovecot
- Courier IMAP
- Cyrus IMAP
- dll

###POP
POP (Post Office Protocol) Server, biasanya menggunakan POP3, digunakan untuk proses penyimpanan email yang nantinya akan diambil oleh email client.
Biasana POP3 ada didalam Imap server. Untuk UW IMAP sama Devecot sudah ada fasilitas POP3 nya tinggal diaktifkan. Kalau Courier sama Cyrus saya belum pernah coba. Ada juga Vm-pop3 yang memang dikhususkan utk akses pop3 untuk `virtual mesin` seperti yang saya pakai dalam percobaan kali ini.

####Authentication
Proses yang terjadi waktu login sama kirim email dikirim secara plain text. Nah, untuk itu diperlukan authentication yang akan mengurusi proses tersebut. banyak juga macam2 jenis authenticationna. SASL, TLS, SSL, dll .
Disini saya memakai `Courier-Authlib` dan `Cyrus-SASL` utk authenticationa, `vm-pop3d` untuk `POP3` na, `Postfix` sebagai mail serverna.

###Ok, lets go to installation:

###1. Install Postfix

	#yast2 -i postfix

###2. Install Courier-Authlib dan Cyrus-SASL

	#yast2 -i courier-authlib cyrus-sasl cyrus-sasl-crammd5 cyrus-sasl-digestmd5 cyrus-sasl-gssapi cyrus-sasl-otp cyrus-sasl-plain cyrus-sasl-saslauthd


###3. Install vm-pop3d

unduh vm-pop3d lalu diekstrak trus di install

	#wget http://www.ibiblio.org/pub/Linux/system/mail/pop/vm-pop3d-1.1.6.tar.gz
	#tar -zxvf vm-pop3d-1.1.6.tar.gz
	#cd vm-pop3d-1.1.6
	#./configure && make && make install

###4. Bikin user baru

	#yast2

Pilih `Security` and `Users -&gt; User and Group Management`

###5. Konfigurasi Postfix

konfigurasi saya seperti ini:

	soft_bounce = no
	queue_directory = /var/spool/postfix
	command_directory = /usr/sbin
	daemon_directory = /usr/lib/postfix
	mail_owner = postfix
	default_privs = nobody
	inet_interfaces = all
	unknown_local_recipient_reject_code = 450
	debug_peer_level = 2
	debugger_command =
        PATH=/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin
        xxgdb $daemon_directory/$process_name $process_id & sleep 5
	sendmail_path = /usr/sbin/sendmail
	newaliases_path = /usr/bin/newaliases
	mailq_path = /usr/bin/mailq
	setgid_group = maildrop
	manpage_directory = /usr/share/man
	sample_directory = /usr/share/doc/packages/postfix/samples
	readme_directory = /usr/share/doc/packages/postfix/README_FILES
	mail_spool_directory = /var/mail
	canonical_maps = hash:/etc/postfix/canonical
	virtual_maps = hash:/etc/postfix/virtual
	relocated_maps = hash:/etc/postfix/relocated
	transport_maps = hash:/etc/postfix/transport
	sender_canonical_maps = hash:/etc/postfix/sender_canonical
	masquerade_exceptions = root
	masquerade_classes = envelope_sender, header_sender, header_recipient
	program_directory = /usr/lib/postfix
	masquerade_domains =
	mydestination = $myhostname, localhost.$mydomain
	defer_transports =
	disable_dns_lookups = no
	relayhost =
	content_filter =
	mailbox_command =
	mailbox_transport =
	smtpd_sender_restrictions = hash:/etc/postfix/access
	smtpd_client_restrictions =
	smtpd_helo_required = no
	smtpd_helo_restrictions =
	strict_rfc821_envelopes = no
	mynetworks_style = subnet
	smtpd_recipient_restrictions = permit_mynetworks,permit_sasl_authenticated,reject_unauth_destination
	#smtpd_recipient_restrictions = permit_sasl_authenticated,reject_unauth_destination
	smtp_sasl_auth_enable = no
	smtpd_sasl_auth_enable = yes
	smtpd_use_tls = no
	smtp_use_tls = no
	alias_maps = hash:/etc/aliases
	mailbox_size_limit = 0
	message_size_limit = 10240000
	#myhostname = linux.local
	#change below information as needed
	myhostname = alinux.web.id
	mynetworks = 198.99.198.183, 127.0.0.1

###6. Konfigurasi file virtual

Tambahkan domain dan nama email na di `/etc/postfix/virtual`

	alinux.web.id           virtual
	deanet@alinux.web.id    deanet

Jalankan perintah berikut:

	# cd /etc/postfix
	# postmap virtual
	# postfix reload

###7. Auto servis
untuk auto serpis biar dijalankan ketika pas reboot tambahkan di `/etc/init.d/boot.local`

	/usr/sbin/saslauthd -a shadow
	/usr/local/sbin/vm-pop3d -d

###8. Restart smua servis

	#postfix restart
	#/usr/sbin/saslauthd -a shadow
	#/usr/local/sbin/vm-pop3d -d

###9. Testing
utk testing kirim dengan menggunakan akun email lain ke nama email yang dibuat tadi. lalu cek di /var/mail/ . apakah ada mail utk user tadi :) . Untuk setting terima dan kirim menggunakan thunderbird seting sperti berikut:

###INCOMING:
server type: `POP3`
server name: `alinux.web.id`
port: `110`
user: `deanet`

###OUTGOING:
server name: `alinux.web.id`
port: `25`

##IMAP
Sekarang saya ingin agar ketika saya bepergian jauh, saya tetap bisa memakai email saya tersebut tanpa harus menyetting / membuat akun di thunderbird. Jawabannya adalah dengan menggunakan webmail. oleh karena itu kita butuh IMAP server dan Squirrelmail.  untuk akses `IMAP` nya saya memakai `UW IMAP`, dan `Squirrelmail` sebagai webmail na.

Ok, langsung aj:

###1. Install UW IMAP

	#yast2 -i imap imap-lib

###2. Konfigurasi imap di `/etc/xinetd.d/imap`

konfigurasi imap saya:

	#
	# imap - pop2 mail daemon
	#
	service pop2
	{
        	disable         = yes
	        socket_type     = stream
	        protocol        = tcp
        	wait            = no
	        user            = root
	        server          = /usr/sbin/ipop2d
	        flags           = IPv4
	}
	#
	# imap - pop3 mail daemon
	#
	service pop3
	{
	        disable         = yes
	        socket_type     = stream
	        protocol        = tcp
	        wait            = no
	        user            = root
        	server          = /usr/sbin/ipop3d
	        flags           = IPv4
	}
	#
	# imap - pop3 mail daemon over tls/ssl
	#
	service pop3s
	{
        	disable         = yes
	        socket_type     = stream
	        protocol        = tcp
        	wait            = no
	        user            = root
	        server          = /usr/sbin/ipop3d
	        flags           = IPv4
	}
	#
	# imap - imap mail daemon
	#
	service imap
	{
	        disable         = no
	        socket_type     = stream
	        protocol        = tcp
	        wait            = no
	        user            = root
	        server          = /usr/sbin/imapd
	        flags           = IPv4
	}
	#
	# imap - imap mail daemon over tls/ssl
	#
	service imaps
	{
	        disable         = yes
	        socket_type     = stream
	        protocol        = tcp
	        wait            = no
	        user            = root
        	server          = /usr/sbin/imapd
	        flags           = IPv4
	}


Untuk memastikan bahwa imap running listen on inet ketik `netstat -ntlp` utk liat port na.

	Active Internet connections (servers and established)
	Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
	tcp        0      0 localhost:953           *:*                     LISTEN      -
	tcp        0      0 *:smtp                  *:*                     LISTEN      -
	tcp        0      0 *:mysql                 *:*                     LISTEN      -
	tcp        0      0 *:pop3                  *:*                     LISTEN      -
	tcp        0      0 *:imap                  *:*                     LISTEN      -
	tcp        0      0 *:www-http              *:*                     LISTEN      -
	tcp        0      0 mail.alinux.web.:domain *:*                     LISTEN      -
	tcp        0      0 127.0.0.2:domain        *:*                     LISTEN      -
	tcp        0      0 localhost:domain        *:*                     LISTEN      -
	tcp        0      0 *:ftp                   *:*                     LISTEN      -
	tcp        0      0 *:domain                *:*                     LISTEN      -
	tcp        0      0 *:ssh                   *:*                     LISTEN      -


##WebMail

###Install Squirremail

prepare:

	# mkdir /usr/local/squirrelmail
	# cd /usr/local/squirrelmail
	# mkdir data temp
	# chgrp nogroup data temp
	# chmod 0730 data temp

Ekstrak paket:

	# cd /usr/local/squirrelmail
	# tar --bzip2 -xvf /usr/local/src/downloads/squirrelmail-1.4.17.tar.bz2
	# mv squirrelmail-1.4.17 www

Konfigruasi squirrel mail:

	# cd /usr/local/squirrelmail
	# www/configure

Select the `"D"` option and then configure SquirrelMail with the `"uw"` preset. Also make sure to set the data and attachment directory settings `("/usr/local/squirrelmail/data"` and `"/usr/local/squirrelmail/temp" respectively)` under `"4. General Options"`. Make any other changes as you see fit, select `"S"` to save and then `"Q"` to quit.

kalo sudah, konfigurasi virtual host biar kelola sub domain na enak. or klo gak langsung aj akses k `http://example.com/squirrelmail/src/configtest.php`

konfigurasi virtual host saya:

        Servername mail.alinux.web.id
        ServerAlias www.mail.alinux.web.id
	#DocumentRoot "/home/deanet/www/mail"
        CustomLog "/var/log/apache2/mail.access-log" combined
        ErrorLog "/var/log/apache2/mail.error-log"
        HostnameLookups Off
        UseCanonicalname Off
        ServerSignature Off
        #
        #       Options All
        #       AllowOverride None
        #       Order allow,deny
        #       Allow from All
	#
	#Alias /s /usr/src/squirrelmail/www
	DocumentRoot "/usr/src/squirrelmail/www"
	<directory /usr/src/squirrelmail/www>
	  Options None
	  AllowOverride None
	  DirectoryIndex index.php
	  Order Allow,Deny
	  Allow from all
	</directory>
	<directory /usr/src/squirrelmail/www/*>
	  Deny from all
	</directory>
	<directory /usr/src/squirrelmail/www/images>
	  Allow from all
	</directory>
	<directory /usr/src/squirrelmail/www/plugins>
	  Allow from all
	</directory>
	<directory /usr/src/squirrelmail/www/src>
	  Allow from all
	</directory>
	<directory /usr/src/squirrelmail/www/templates>
	  Allow from all
	</directory>
	<directory /usr/src/squirrelmail/www/themes>
	  Allow from all
	</directory>
	<directory /usr/src/squirrelmail/www/contrib>
	  Order Deny,Allow
	  Deny from All
	  Allow from 127
	  Allow from 10
	  Allow from 192
	</directory>
	<directory /usr/src/squirrelmail/www/doc>
	  Order Deny,Allow
	  Deny from All
	  Allow from 127
	  Allow from 10
	  Allow from 192
	</directory>

Karena "<a href="http://squirrelmail.org/docs/admin/admin-10.html" target="_new">uw-imapd server disables plain text logins by default in 2002 and newer versions</a>", maka tambahkan set `disable-plaintext nil` di `/etc/c-client.cf` agar kita bisa mengakses imap server dengan squirrelmail.

konfigurasi saya:

	set rshpath /usr/bin/rsh
	set sshpath /usr/bin/ssh
	set disable-plaintext nil

ude deh .. .selesai ... huff ...

gud lak ... ;)

cmiiw :)

Thanks

Referensi:

1. [forum.wowtutorial.org](http://forum.wowtutorial.org/index.php?showtopic=403)
2. [sonicresolutions.com](http://www.sonicresolutions.com/tech/howto_postfix_vmpop3d.html)
3. [flurdy.com](http://flurdy.com/docs/postfix/#config-extra-webmail)
4. [opensuse.or.id](http://opensuse.or.id/panduan/server-setup/email-server/instalasi-mail-server-dengan-postfix-uw-imap/)
5. [home.kivu.nl](http://home.kivu.nl/imap_setup.html)
6. [Official Installation Guide on Squirrelmail](http://squirrelmail.org/docs/admin/admin-3.html)
7. [Official solving problems on Squirrelmail](http://squirrelmail.org/docs/admin/admin-10.html)
8. [modul praktikum](http://josh.staff.ugm.ac.id/seminar/Modul%20Mail%20Server%20with%20Postfix.pdf)
