--- 
layout: post
title: Install squirrel webmail maildir support
date: 2009-09-08 08:00:09
---

With Courier-imap, we can use postfix with squirrel webmail supported with Maildir.

##Postfix with Maildir

To use the Maildir in postfix just add `home_mailbox = Maildir/` on `main.cf`

##Configuration Postfix with Maildir:

{% highlight bash %}
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
          PATH = /bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin
          xxgdb $ daemon_directory / $ process_name $ process_id & sleep 5
sendmail_path = /usr/sbin/sendmail
newaliases_path = /usr/bin/newaliases
mailq_path = /usr/bin/mailq
setgid_group = maildrop
manpage_directory = /usr/share/man
sample_directory = /usr/share/doc/packages/postfix/samples
readme_directory = /usr/share/doc/packages/postfix/README_FILES
mail_spool_directory = /var/mail
canonical_maps = hash: /etc/postfix/Canonical
virtual_maps = hash: /etc/postfix/virtual
relocated_maps = hash: /etc/postfix/relocated
transport_maps = hash: /etc/postfix/transport
sender_canonical_maps = hash: /etc/postfix/sender_canonical
masquerade_exceptions = root
masquerade_classes = envelope_sender, header_sender, header_recipient
program_directory = /usr/lib/postfix
masquerade_domains =
mydestination = $ myhostname, localhost. $ mydomain
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
smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
# smtpd_recipient_restrictions = permit_sasl_authenticated, reject_unauth_destination
smtp_sasl_auth_enable = no
smtpd_sasl_auth_enable = yes
smtpd_use_tls = no
smtp_use_tls = no
alias_maps = hash: /etc/aliases
mailbox_size_limit = 0
message_size_limit = 10240000
# myhostname = linux.local
# change below information as needed
myhostname = local.net
mynetworks = 10.100.100.21, 127.0.0.1
home_mailbox = Maildir /
{% endhighlight %}


##Testing SMTP:

Open two shell. First for telnet command, and second shell for monitoring logs `/var/log/mail`

{% highlight bash %}
1fvu-linux: /home/deanet# telnet localhost 25
Trying 127.0.0.1 ...
Connected to localhost.
Escape character is'^]'.
220 local.net ESMTP Postfix
helo local.net
250 local.net
mail from: test@aja.net
250 2.1.0 Ok
rcpt to: deanet@local.net
250 2.1.5 Ok
data
354 End data with <cr> <lf>. <cr> <lf>
halo testaja
.
250 2.0.0 Ok: queued as B753761A3
quit
221 2.0.0 Bye
Connection closed by foreign host.
1fvu-linux: /home/deanet#
{% endhighlight %}

when you type `tail -f /var/log/mail` on second shell, it will results:

{% highlight xml %}
Aug 21 06:17:15 linux-1fvu postfix / smtpd [10556]: connect from localhost [127.0.0.1]
Aug 21 06:17:39 linux-1fvu postfix / smtpd [10556]: B753761A3: client = localhost [127.0.0.1]
Aug 21 06:18:10 linux-1fvu postfix / cleanup [10559]: B753761A3: message-id =
Aug 21 06:18:10 linux-1fvu postfix / qmgr [7987]: B753761A3:  from =, size = 323, nrcpt = 1 (queue active)
Aug 21 06:18:10 linux-1fvu postfix / local [10560]: B753761A3:  to =, relay = local, delay = 39, delays = 39/0.05/0/0.01, DSN = 2.0 .0, status = sent (delivered to Maildir)
Aug 21 06:18:10 linux-1fvu postfix / qmgr [7987]: B753761A3: removed
Aug 21 06:18:13 linux-1fvu postfix / smtpd [10556]: disconnect from localhost [127.0.0.1]
{% endhighlight %}


Messages are stored in `~/Maildir/new/`

{% highlight xml %}
1fvu-linux: /home/deanet# cat Maildir/new/1250810290.V802Ib57bM671042.linux-1fvu
Return-Path: <test@aja.net>
X-Original-To: deanet@local.net
Delivered-To: deanet@local.net
Received: from local.net (localhost [127.0.0.1])
         by local.net (Postfix) with SMTP id B753761A3
         for <deanet@local.net>; Fri, 21 Aug 2009 06:17:31 0700 (WIT)
Message-Id: <@ 20090820231739.B753761A3 local.net>
Date: Fri, 21 Aug 2009 06:17:31 0700 (WIT)
From: test@aja.net
To: undisclosed-Recipients:;
halo testaja
{% endhighlight %}


##Courrier-imap.

Install:
	
	# zypper install courrier-imap

run courrier-imap daemon :

	# rccourier-imap start


**Testing Courier-imap :**

	1fvu-linux: /home/deanet # telnet localhost 143
	Trying 127.0.0.1 ...
	Connected to localhost.
	Escape character is'^]'.
	* OK [IMAP4rev1 capability UIDPLUS CHILDREN Namespace = Thread Thread ORDEREDSUBJECT = Idle REFERENCES Sort QUOTA ACL ACL2 = UNION] Courier-IMAP ready. Copyright 1998-2008 Double Precision, Inc.. See Copying for distribution information.
	a login username password
	a OK LOGIN Ok.
	a logout
	* BYE Courier-IMAP server shutting down
	a OK LOGOUT completed
	Connection closed by foreign host.
	1fvu-linux: /home/deanet#


##Squirrel webmail.

Install:

	# cd /srv/www/htdocs
	# tar-xzvf Squirrelmail-1.4.17.tar.gz
	# mv-1.4.17 Squirrelmail Squirrelmail

configuring executable file:

	# squirrelmail/configure

Select the `D` option and then configure Squirrelmail with the `UW` preset. Also make sure to set the data and attachment settings directory `/usr/local/squirrelmail/data` and `/usr/local/squirrelmail/temp` respectively under `4. General Options` . Make any other changes as you see fit, select `S` to save and then `Q` to quit.</p>


##Configuration squirrel in the apache directory:

{% highlight apacheconf %}
<directory /srv/www/htdocs/squirrelmail>
   Options None
   AllowOverride None
   DirectoryIndex index.php
   Order Allow, Deny
   Allow from all
</ Directory>
<directory /srv/www/htdocs/squirrelmail/*>
   Deny from all
</ Directory>
<directory /srv/www/htdocs/squirrelmail/images>
   Allow from all
</ Directory>
<directory /srv/www/htdocs/squirrelmail/plugins>
   Allow from all
</ Directory>
<directory /srv/www/htdocs/squirrelmail/src>
   Allow from all
</ Directory>
<directory /srv/www/htdocs/squirrelmail/templates>
   Allow from all
</ Directory>
<directory /srv/www/htdocs/squirrelmail/themes>
   Allow from all
</ Directory>
<directory /srv/www/htdocs/squirrelmail/contrib>
   Order Deny, Allow
   Deny from All
   Allow from 127
   Allow from 10
   Allow from 192
</ Directory>
<directory /srv/www/htdocs/squirrelmail/doc>
   Order Deny, Allow
   Deny from All
   Allow from 127
   Allow from 10
   Allow from 192
</ Directory>
{% endhighlight %}

##Testing squirrel:

access on `http://localhost/squirrelmail/src/configtest.php`
On this experiment I use Opensuse. Open SUSE 11 has been included as the default postfix mail system. :)

Thanks

References:
1. [http://www.perturb.org/display/entry/691/](http://www.perturb.org/display/entry/691/)
2. [http://squirrelmail.org/docs/admin/admin-3.html](http://squirrelmail.org/docs/admin/admin-3.html)
