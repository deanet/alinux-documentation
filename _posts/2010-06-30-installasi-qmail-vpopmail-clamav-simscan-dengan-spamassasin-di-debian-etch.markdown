--- 
layout: post_new
title: Installasi Qmail, Vpopmail, ClamAV, Simscan, Spamassasin di Debian Etch
categories: [install, Qmail, Vpopmail, ClamAV, Simscan, Spamasassin, debian, etch]
date: 2010-06-30 05:52:53
---

##Muqadimah

`Qmail` = Mail Transfer Agent. Modern SMTP server. Dapat dijalankan di RH,Debian, HP-UX,Gentoo, OpenBSD. [lihat cara kerja qmail](http://www.nrg4u.com/qmail/the-big-qmail-picture-103-p1.gif)

`Vpopmail` = POP3 server. Manejemen akun email dengan virtual email domain, dapat dijalankan di qmail atau Postfix mail server. Disini
memakai `mysql` sebagai back-end nya.

`Simscan` = Simcan digunakan untuk menolak email yang kemungkinan berisi spam,virus,ataupun attachments file.

`chkuser` = anti-SPAM features.

`ClamAV` = Anti Virus.

`SpamAssassin` = Anti Spam.

##Persiapan
*semua dijalankan dengan user root*

###Setting repository:
{% highlight bash %}
deb http://ftp.debian.org/debian/ etch main contrib non-free
deb-src http://ftp.debian.org/debian/ etch main contrib non-free
deb     http://debian.iuculano.it/apt  etch main contrib non-free
deb-src http://debian.iuculano.it/apt  etch main contrib non-free
{% endhighlight %}

###tambahkan key public:

{% highlight xml %}
# wget http://debian.iuculano.it/AE3BE9AA.gpg -O- | apt-key add -
{% endhighlight %}

lalu jalankan `apt-get update`

###Install mysql server
Install `mysql server` lalu buat database dengan nama `vpopmail` terus kasih `grant`.

{% highlight xml %}
# apt-get install mysql-server
{% endhighlight %}

jangan lupa rubah password root `mysql`

{% highlight xml %}
# mysqladmin -u root password passwordbaru
{% endhighlight %}

bikin database `vpopmail`

{% highlight mysql %}
mysql> create database vpopmail;
mysql> grant all privileges on vpopmail.* to 'vpopmail'@'localhost' identified by 'vpopmail123' with grant option;
{% endhighlight %}

###Install `dpatch`, `recode`, dan `telnet`.
`dpatch` digunakan untuk build `qmail`, `recode` digunakan untuk generate passwd `base64`, dan telnet ya tentu saja untuk remote client :).

{% highlight xml %}
# apt-get install dpatch recode telnet
{% endhighlight %}


##Installasi Qmail
Cek dulu ada `MTA` laen gak ? .. kalo ada remove segera, contoh: exim.

{% highlight xml %}
# apt-get remove exim4 exim4-base exim4-config exim4-daemon-light
{% endhighlight %}

jika `exim` susah dibuang, jalankan perintah ini:

{% highlight xml %}
# dpkg --force-depends --purge exim4 exim4-base exim4-config exim4-daemon-light
{% endhighlight %}

Kalo sudah terus install qmailna:

{% highlight xml %}
# apt-get install qmail-src spamassassin vpopmail-mysql spamc razor pyzor ucspi-tcp-src libmailtools-perl libmail-spf-query-perl libsys-hostname-long-perl
{% endhighlight %}

jika ada error:

{% highlight bash %}
stat /usr/bin/tcpserver: No such file or directory
{% endhighlight %}

ini karena kita install `ucspi-tcp`, build saja `ucspi-tcp` nya:

{% highlight xml %}
# build-ucspi-tcp
{% endhighlight %}

terus build qmail:

{% highlight xml %}
# build-qmail
{% endhighlight %}

##Konfig `qmail`
set hostname mail servernya:

{% highlight bash %}
echo "mail.denbaguse.ta" > /etc/qmail/me
{% endhighlight %}

##Konfig Vpopmail
set username `mysql` sama password untuk `vpopmail`

{% highlight xml %}
# vim /etc/vpopmail/vpopmail.mysql
	localhost|0|root|passwordbaru|vpopmail
{% endhighlight %}

##Jalankan service
Jalankan `qmail` nya dan `pop3` server atau `vpopmail` nya

{% highlight xml %}
# /etc/init.d/qmail start
# /etc/init.d/vpopmail-mysql start
{% endhighlight %}
 
##Test
Menambahkan domain dan email address

{% highlight bash %}
denbaguse:/home/alinux# vadddomain testaja.lg
Please enter password for postmaster:        
enter password again:                        
{% endhighlight %}

domain: `testaja.lg`
passwd: `testaja`

Encrypt email address dan password ke dalam format `base64`

email address:

{% highlight bash %}
denbaguse:/home/alinux# echo -en "postmaster@testaja.lg" | recode data..base64
cG9zdG1hc3RlckB0ZXN0YWphLmxn                                                  
{% endhighlight %}

password:

{% highlight bash %}
denbaguse:/home/alinux# echo -en "testaja" | recode data..base64              
dGVzdGFqYQ==
{% endhighlight %}

Jalankan `tail -f /var/log/syslog`

##Test SMTP server
{% highlight bash %}
denbaguse:/home/alinux# telnet localhost 25              
Trying 127.0.0.1...                                      
Connected to localhost.
Escape character is '^]'.
220 mail.denbaguse.ta ESMTP
AUTH LOGIN
334 VXNlcm5hbWU6
cG9zdG1hc3RlckB0ZXN0YWphLmxn
334 UGFzc3dvcmQ6
dGVzdGFqYQ==
235 ok, postmaster@testaja.lg, go ahead (#2.0.0)
mail from: test@testaja.com
250 ok
RCPT TO: postmaster@testaja.lg
250 ok
DATA
354 go ahead
halooooo
.
250 ok 1276913544 qp 13750
quit
221 mail.denbaguse.ta
Connection closed by foreign host.
{% endhighlight %}


###hasil tail:
{% highlight bash %}
Jun 19 09:12:14 denbaguse qmail: 1276913534.111443 CHKUSER accepted any rcpt: from <test@testaja.com:postmaster@testaja.lg:> remote
<:unknown:127.0.0.1> rcpt <postmaster@testaja.lg> : accepted any recipient for any rcpt domain                                           
Jun 19 09:12:14 denbaguse qmail: 1276913534.111512 qmail-smtpd: pid 13748 RCPT TO: <postmaster@testaja.lg>                               
Jun 19 09:12:24 denbaguse qmail: 1276913544.622077 new msg 78833                                       
Jun 19 09:12:24 denbaguse qmail: 1276913544.622156 info msg 78833: bytes 190 from <test@testaja.com> qp 13750 uid 0                                          Jun 19 09:12:24 denbaguse qmail: 1276913544.622856 starting delivery 1: msg 78833 to local testaja.lg-postmaster@testaja.lg              
Jun 19 09:12:24 denbaguse qmail: 1276913544.622892 status: local 1/10 remote 0/20                      
Jun 19 09:12:24 denbaguse qmail: 1276913544.684768 delivery 1: success: did_0+0+1/                     
Jun 19 09:12:24 denbaguse qmail: 1276913544.684860 status: local 0/10 remote 0/20                      
Jun 19 09:12:24 denbaguse qmail: 1276913544.684911 end msg 78833       
{% endhighlight %}


###Isi email:
{% highlight bash %}
denbaguse:/home/alinux# cat /var/lib/vpopmail/domains/testaja.lg/postmaster/Maildir/new/1276913544.13752.denbaguse\,S\=258
Return-Path: <test@testaja.com>
Delivered-To: postmaster@testaja.lg
Received: (qmail 13750 invoked by uid 0); 19 Jun 2010 09:12:20 +0700
Received: from unknown (postmaster@testaja.lg@127.0.0.1)
by 127.0.0.1 with ESMTPA; 19 Jun 2010 09:12:20 +0700
halooooo
denbaguse:/home/alinux#
{% endhighlight %}
	
	
##Test POP3
{% highlight bash %}
denbaguse:/home/alinux# telnet localhost pop3
Trying 127.0.0.1...                          
Connected to localhost.                      
Escape character is '^]'.                    
+OK <21325.1277029415@denbaguse.ta>          
USER postmaster@testaja.lg
+OK
PASS testaja
+OK
LIST
+OK
1 258
2 267
.
RETR 1
+OK 258 octets
Return-Path: <test@testaja.com>
Delivered-To: postmaster@testaja.lg
Received: (qmail 13750 invoked by uid 0); 19 Jun 2010 09:12:20 +0700
Received: from unknown (postmaster@testaja.lg@127.0.0.1)
by 127.0.0.1 with ESMTPA; 19 Jun 2010 09:12:20 +0700
halooooo
.
quit
+OK
Connection closed by foreign host.
denbaguse:/home/alinux#
{% endhighlight %}


##Test chkuser
{% highlight bash %}
denbaguse:/home/alinux# telnet localhost 25
Trying 127.0.0.1...                        
Connected to localhost.
Escape character is '^]'.
220 mail.denbaguse.ta ESMTP
EHLO
250-mail.denbaguse.ta
250-PIPELINING
250-8BITMIME
250-SIZE 0
250 AUTH LOGIN PLAIN CRAM-MD5
mail from: test@asd.tett
550 5.1.8 sorry, can't find a valid MX for sender domain (chkuser)
mail from: test@test.com
250 ok
rcpt to: test@tests.tstt
553 sorry, that domain isn't in my list of allowed rcpthosts (#5.7.1)
rcpt to: test@test.bogus
550 5.1.1 sorry, no mailbox here by that name (chkuser)
RSET
250 flushed
quit
221 mail.denbaguse.ta
Connection closed by foreign host.
denbaguse:/home/alinux#
{% endhighlight %}


##Instal Simscan
{% highlight xml %}
# apt-get install qmailadmin autorespond ezmlm-src clamav clamav-daemon clamav-freshclam ripmime
# build-ezmlm
# wget http://downloads.sourceforge.net/simscan/simscan-1.4.0.tar.gz
# tar -xzvf simscan-1.4.0.tar.gz 
# cd simscan-1.4.0
# wget http://qmail.jms1.net/simscan/simscan-1.4.0-clamav.3.patch
# cat simscan-1.4.0-clamav.3.patch | patch -p1
# ./configure --enable-user=clamav --enable-clamav=y --enable-custom-smtp-reject=y --enable-attach=y --enable-spam=y
	--enable-spam-hits=14 --enable-spamc-user=y --enable-received=y --enable-clamavdb-path=/var/lib/clamav --enable-spam-auth-user=n
	--enable-quarantinedir=/var/qmail/quarantine
# make
# make install
{% endhighlight %}

###aktifkan qmail simscan:

{% highlight xml %}
# vim /etc/init.d/qmail 
QMAILQUEUE="/var/qmail/bin/simscan"
export QMAILQUEUE
{% endhighlight %}

###Restart qmail:
	
{% highlight xml %}
# /etc/init.d/qmail restart
{% endhighlight %}


##Test simscan
{% highlight bash %}
denbaguse:/home/alinux# echo "test aja" > mailtest.txt
denbaguse:/home/alinux# env QMAILQUEUE=/var/qmail/bin/simscan SIMSCAN_DEBUG=2 /var/qmail/bin/qmail-inject postmaster@testaja.lg <
mailtest.txt
simscan: starting: work dir: /var/qmail/simscan/1277102187.556394.25609
simscan: calling clamdscan
simscan: cdb looking up version clamav
simscan: normal clamdscan return code: 0
simscan: calling spamc
simscan: calling /usr/bin/spamc  spamc -u postmaster@testaja.lg
simscan: cdb looking up version spam
simscan:[25608]:CLEAN (0.00/0.00):3.3011s::(null):root@mail.denbaguse.ta:postmaster@testaja.lg
simscan: done, execing qmail-queue
simscan: qmail-queue exited 0
denbaguse:/home/alinux#
{% endhighlight %}

##Konfig Relay tcpserver
buka file `/etc/tcp.smtp` lalu isi sesuai dengan kebutuhan:
{% highlight xml %}
# vim /etc/tcp.smtp
127.0.0.1:allow,RELAYCLIENT=""
192.168.0.177:allow,CHKUSER_RCPTLIMIT="15",CHKUSER_WRONGRCPTLIMIT="3",QMAILQUEUE="/var/qmail/bin/simscan"
:deny	
{% endhighlight %}
	
Semua host digagalkan kecuali host `localhost` dan host `192.168.0.177`. Save lalu run `/etc/init.d/qmail cdb` terus restart `/etc/init.d/qmail restart`

test di localhost:
{% highlight bash %}
denbaguse:/etc/qmail# telnet localhost 25
Trying 127.0.0.1...                      
Connected to localhost.                  
Escape character is '^]'.                
220 mail.denbaguse.ta ESMTP              
quit                                     
221 mail.denbaguse.ta                    
Connection closed by foreign host.       
denbaguse:/etc/qmail#
{% endhighlight %}

test di ip `192.168.0.177`:
{% highlight bash %}
alinux@debian:~$ telnet 192.168.0.5 25
Trying 192.168.0.5...
Connected to 192.168.0.5.
Escape character is '^]'.
220 mail.denbaguse.ta ESMTP
quit
221 mail.denbaguse.ta
Connection closed by foreign host.
alinux@debian:~$ cd /home/alinux/alinux/
alinux@debian:~/alinux$
{% endhighlight %}


test di host laen:
{% highlight bash %}
alinux@ajisaka:~$ telnet 192.168.0.5 25
Trying 192.168.0.5...
Connected to 192.168.0.5.
Escape character is '^]'.
Connection closed by foreign host.
alinux@ajisaka:~$
{% endhighlight %}



##Test SpamAssassin

{% highlight bash %}
alinux@debian:~$ telnet 192.168.0.5 25                      
Trying 192.168.0.5...                                       
Connected to 192.168.0.5.                                   
Escape character is '^]'.                                   
220 mail.denbaguse.ta ESMTP                                 
EHLO                                                        
250-mail.denbaguse.ta                                       
250-PIPELINING                                              
250-8BITMIME                                                
250-SIZE 0                                                  
250 AUTH LOGIN PLAIN CRAM-MD5                               
MAIL                                                        
250 ok                                                      
RCPT TO: alinux@testaja.lg                                  
250 ok                                                      
DATA                                                        
354 go ahead                                                
Congratulations! You have been selected to receive 2 FREE 2 Day VIP Passes to
Universal Studios!

Click here http://209.61.190.180

As an added bonus you will also be registered to receive vacations discounted 25%-
75%!


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
his mailing is done by an independent marketing co.
We apologize if this message has reached you in error.
Save the Planet, Save the Trees! Advertise via E mail.
No wasted paper! Delete with one simple keystroke!
Less refuse in our Dumps! This is the new way of the new millennium
To be removed please reply back with the word "remove" in the subject line.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.
quit
250 ok 1277148214 qp 11685
221 mail.denbaguse.ta
Connection closed by foreign host.
alinux@debian:~$
{% endhighlight %}

###Cek header email spamAssassin:
{% highlight bash %}
denbaguse:~# cat mail/1277148214.11693.denbaguse\,S\=3160 
Return-Path: <>                                           
Delivered-To: alinux@testaja.lg                           
Received: (qmail 11691 invoked by uid 0); 22 Jun 2010 02:23:34 +0700
Received: by simscan 1.4.0 ppid: 11684, pid: 11685, t: 11.5012s                
 scanners: clamav: 0.95.2/m:52/d:11242 spam: 3.2.5                     
Received: from localhost by denbaguse.ta                                       
        with SpamAssassin (version 3.2.5);                                     
        Tue, 22 Jun 2010 02:23:34 +0700                                        
X-Spam-Flag: YES                                                               
X-Spam-Checker-Version: SpamAssassin 3.2.5 (2008-06-10) on denbaguse.ta        
X-Spam-Level: *****                                                            
X-Spam-Status: Yes, score=5.9 required=5.0 tests=ALL_TRUSTED,EXCUSE_4,         
MISSING_DATE,MISSING_HB_SEP,MISSING_HEADERS,MISSING_MID,MISSING_SUBJECT,
   NORMAL_HTTP_TO_IP autolearn=no version=3.2.5                            
MIME-Version: 1.0                                                               
Content-Type: multipart/mixed; boundary="----------=_4C1FBC36.2B3B6E49"         
	This is a multi-part message in MIME format.

------------=_4C1FBC36.2B3B6E49
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline                 
Content-Transfer-Encoding: 8bit             
Spam detection software, running on the system "denbaguse.ta", has
identified this incoming email as possible spam.  The original message
has been attached to this so you can view it (if it isn't spam) or label
similar future email.  If you have any questions, see                   
the administrator of that system for details.                           
	Content preview:  Congratulations! You have been selected to receive 2 FREE
	2 Day VIP Passes to Universal Studios! Click here http://209.61.190.180 As
	an added bonus you will also be registered to receive vacations discounted
	25%- 75%! [...]                                                           
Content analysis details:   (5.9 points, 5.0 required)
 pts rule name              description
---- ---------------------- --------------------------------------------------
-1.4 ALL_TRUSTED            Passed through trusted hosts only via SMTP        
 0.0 MISSING_MID            Missing Message-Id: header                        
 0.0 MISSING_DATE           Missing Date: header                              
 2.5 MISSING_HB_SEP         Missing blank line between message header and body
 1.6 MISSING_HEADERS        Missing To: header                                
 1.9 EXCUSE_4               BODY: Claims you can be removed from the list     
 0.0 NORMAL_HTTP_TO_IP      URI: Uses a dotted-decimal IP address in URL      
 1.3 MISSING_SUBJECT        Missing Subject: header                           

	------------=_4C1FBC36.2B3B6E49
Content-Type: message/rfc822; x-spam-type=original
Content-Description: original message before SpamAssassin
Content-Disposition: inline                              
Content-Transfer-Encoding: 8bit                          

Received: from unknown (HELO ) (192.168.0.177)
  by 192.168.0.5 with SMTP; 22 Jun 2010 02:23:22 +0700
Congratulations! You have been selected to receive 2 FREE 2 Day VIP Passes to
Universal Studios!

Click here http://209.61.190.180

As an added bonus you will also be registered to receive vacations discounted 25%-
75%!


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
This mailing is done by an independent marketing co.
We apologize if this message has reached you in error.
Save the Planet, Save the Trees! Advertise via E mail.
No wasted paper! Delete with one simple keystroke!
Less refuse in our Dumps! This is the new way of the new millennium
To be removed please reply back with the word "remove" in the subject line.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

------------=_4C1FBC36.2B3B6E49--

denbaguse:~#
{% endhighlight %}
	

##Test Clamav

{% highlight bash %}
denbaguse:~# clamdscan test
WARNING: Can't access file /root/test
/root/test: OK
----------- SCAN SUMMARY -----------
Infected files: 0
Time: 0.011 sec (0 m 0 s)
denbaguse:~#
{% endhighlight %}

Referensi:

<a href="http://wiki.debian.iuculano.it/quick_howto" target="_new">http://wiki.debian.iuculano.it/quick_howto</a>
<br/>
<a href="http://www.qmailwiki.org/index.php/Simscan/Related_Docs/Simscan_ClamAV_Chkuser_Installation_Guide" target="_new">http://www.qmailwiki.org/index.php/Simscan</a>
<br/>
<a href="http://www.qmailwiki.org/SimScanTips" target="_new">http://www.qmailwiki.org/SimScanTips</a>
<br/>
<a href="http://wiki.apache.org/spamassassin/UsingPyzor" target="_new">http://wiki.apache.org/spamassassin/UsingPyzor</a>
<br/>
<a href="http://commons.oreilly.com/wiki/index.php/SpamAssassin/Integrating_SpamAssassin_with_qmail" target="_new">http://commons.oreilly.com</a>
<br/>
<a href="http://old.nabble.com/clamd-not-creating-socket-or-pid-file-td21320116.html" target="_new">http://old.nabble.com</a>
<br/>
<br/>
