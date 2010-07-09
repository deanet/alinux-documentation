--- 
layout: post
title: How to install Postfix, UW IMAP and RoundCube webmail
date: 2009-07-16 16:07:00
---

Sudah lama gak update blog. ok gan, masih dengan topik yang bikin njlimet.. sansaya ruwet.. tambah njlimet.. marahi petheng ndedhet.. terus gremet-gremet ... :Dk *demam bhs kaskus* :ngacir: .

klik cendol nya gan jangan lupa ..

percobaan ini menggunakan mesin `openSUSE 11.0 (i586)` via `zypper`.

##Requirement:
####<a href="http://numpanglewat.wordpress.com/2009/05/05/installasi-bind-apache2-mysql-php-dan-konfigurasi-dns-serta-virtual-host-di-opensuse/" target="_new">Apache server &amp; MySQL server</a>

##Install zypper

	# yast -i zypper

##Install Postfix

#####1. Install

	# zypper install postfix

####2. Konfigurasi `/etc/postfix/main.cf`

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

####3. Konfigurasi /etc/postfix/virtual

	alinux.web.id           virtual
	deanet@alinux.web.id    deanet

####4. Start Postfix Mail Server

	# rcpostfix start


##Install UW IMAP

####1. Install

	# zypper install imap imap-lib

####2. Konfigurasi imap di /etc/xinetd.d/imap

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


####3. Add `set disable-plaintext nil` di `/etc/c-client.cf`

	set rshpath /usr/bin/rsh
	set sshpath /usr/bin/ssh
	set disable-plaintext nil

####4. Done

.


##Install Roundcube

####1. unduh roundcube di <a href="http://roundcube.net/downloads" target="_new">http://roundcube.net/downloads</a>

	# wget http://sourceforge.net/project/downloading.php?group_id=139281&filename=roundcubemail-0.2.2.tar.gz
	# tar -xzvf roundcubemail-0.2.2.tar.gz
	# cd roundcubemail-0.2.2


####2. Beri Hak akses writeable all pada temp dan logs

	# chmod 777 temp logs

####3. Buat database roundcube

	# mysql -u root -p

	mysql> CREATE DATABASE database_roundcubemail;
	GRANT ALL PRIVILEGES ON database_roundcubemail.* TO user_sql@localhost IDENTIFIED BY 'password_user_mysql';

simpan lalu keluar

	mysql> FLUSH PRIVILEGES;
	mysql> quit


####4.  Dumping data SQL roundcube

	mysql> roundcubemail < SQL/mysql.initial.sql

####5. Konfigurasi Roundcube

	# cp config/db.inc.php.dist config/db.inc.php
	# cp config/main.inc.php.dist config/main.inc.php

edit `db.inc.php`

	# vi db.inc.php

cari bagian dibawah ini dan sesuaikan dengan user mysql yang kita buat tadi

	$rcmail_config['db_dsnw'] = 'mysql://user_mysql:password_user_mysql@localhost/database_roundcubemail';


edit `main.inc.php`

	vi main.inc.php

cari bagian dibawah ini dan sesuaikan.

	$rcmail_config['default_host'] = 'localhost';

atau bisa juga dengan multihost (*domain mesti kudu point ke web server na*)

	$rcmail_config['default_host'] = array('deanet.co.cc', 'alinux.web.id');

####6. selesai / done.


##Troubleshooting

	Server internal Error 500

`Solusi`: set Apache directive

	{% highlight apacheconf %}
	<directory "/home/deanet/public_html/deanet.co.cc/mail">
                Options All
                AllowOverride All
                Order allow,deny
                Allow from All
	</directory>
	{% endhighlight %}


Referensi:

1. [Install postfix via yast](http://numpanglewat.wordpress.com/2009/05/19/installasi-postfix-saslauthd-vm-pop3d-squirrelmail-opensuse/)
2. [How to install RoundCube webmail](http://trac.roundcube.net/wiki/Howto_Install)
3. [How to config RoundCube webmail](http://trac.roundcube.net/wiki/Howto_Config)
4. [How to install and configuring apache2, mysql, bind dns](/2009/05/05/installasi-bind-apache2-mysql-php-dan-konfigurasi-dns-serta-virtual-host-di-opensuse/)
