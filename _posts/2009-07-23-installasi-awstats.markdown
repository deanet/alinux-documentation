--- 
layout: post
title: Installasi Awstats
date: 2009-07-23 23:06:16
---

`AWStats` adalah gratis handal dan alat yang menghasilkan featureful lanjutan web, streaming, atau mail server ftp statistik, grafis. Log analyzer ini berfungsi sebagai CGI atau dari baris perintah dan menunjukkan semua kemungkinan berisi informasi login Anda, dalam beberapa grafis halaman web. menggunakan sebagian informasi file untuk dapat memproses file log besar, sering dan cepat. Hal ini dapat menganalisa file log dari semua alat-alat utama server seperti Apache file log (NCSA gabungan / XLF / ELF format atau log umum / CLF log format), WebStar, IIS (log W3C format) dan banyak lainnya web, proxy, wap, streaming server, mail server dan ftp server.

Requirement:
===========

##perl

RH based:

	# zypper install perl

Debian based:

	# apt-get install perl


Installasinya cukup mudah koq..

####1. Get Package

	# wget http://sourceforge.net/projects/awstats/files/AWStats/awstats-6.9.tar.gz/download

####2. Extract Package and rename awstats directory

	# tar -xzvf awstats-6.9.tar.gz
	# mv awstats-6.9 awstats

####3. Change into current directory and run `awstats_configure.pl`

	# cd awstats/tools/
	# ./awstats_configure.pl

	----- AWStats awstats_configure 1.0 (build 1.8) (c) Laurent Destailleur -----
	This tool will help you to configure AWStats to analyze statistics for
	one web server. You can try to use it to let it do all that is possible
	in AWStats setup, however following the step by step manual setup
	documentation (docs/index.html) is often a better idea. Above all if:
	- You are not an administrator user,
	- You want to analyze downloaded log files without web server,
	- You want to analyze mail or ftp log files instead of web log files,
	- You need to analyze load balanced servers log files,
	- You want to 'understand' all possible ways to use AWStats...
	Read the AWStats documentation (docs/index.html).
	.
	-----> Running OS detected: Linux, BSD or Unix
	Warning: AWStats standard directory on Linux OS is '/usr/local/awstats'.
	If you want to use standard directory, you should first move all content
	of AWStats distribution from current directory:
	/home/deanet/public_html/deanet.co.cc/awstats
	to standard directory:
	/usr/local/awstats
	And then, run configure.pl from this location.
	Do you want to continue setup from this NON standard directory [yN] ? y '<- ketik y'
	.
	-----> Check for web server install
	.
	Enter full config file path of your Web server.
	Example: /etc/httpd/httpd.conf
	Example: /usr/local/apache2/conf/httpd.conf
	Example: c:\Program files\apache group\apache\conf\httpd.conf
	Config file path ('none' to skip web server setup):
	> /etc/apache2/httpd.conf '<- isikan path konfigurasi apache na'
	.
	-----> Check and complete web server config file '/etc/apache2/httpd.conf'
	  Add 'Alias /awstatsclasses "/home/deanet/public_html/deanet.co.cc/awstats/wwwroot/classes/"'
	  Add 'Alias /awstatscss "/home/deanet/public_html/deanet.co.cc/awstats/wwwroot/css/"'
	  Add 'Alias /awstatsicons "/home/deanet/public_html/deanet.co.cc/awstats/wwwroot/icon/"'
	  Add 'ScriptAlias /awstats/ "/home/deanet/public_html/deanet.co.cc/awstats/wwwroot/cgi-bin/"'
	  Add '<directory>' directive
	  AWStats directives added to Apache config file.
	.
	-----> Update model config file '/home/deanet/public_html/deanet.co.cc/awstats/wwwroot/cgi-bin/awstats.model.conf'
	  File awstats.model.conf updated.
	.
	-----> Need to create a new config file ?
	Do you want me to build a new AWStats config/profile
	file (required if first install) [y/N] ? y '<- ketik y'
	.
	-----> Define config file name to create
	What is the name of your web site or profile analysis ?
	Example: www.mysite.com
	Example: demo
	Your web site, virtual server or profile name:
	> deanet.co.cc <strong><- isi nama domain</strong>
	.
	-----> Define config file path
	In which directory do you plan to store your config file(s) ?
	Default: /etc/awstats
	Directory path to store config file(s) (Enter for default): 'tekan enter'
	>
	.
	-----> Create config file '/etc/awstats/awstats.deanet.co.cc.conf'
	 Config file /etc/awstats/awstats.deanet.co.cc.conf created.
	.
	-----> Restart Web server with '/sbin/service httpd restart'
	service: no such service httpd
	.
	-----> Add update process inside a scheduler
	Sorry, configure.pl does not support automatic add to cron yet.
	You can do it manually by adding the following command to your cron:
	/home/deanet/public_html/deanet.co.cc/awstats/wwwroot/cgi-bin/awstats.pl -update -config=deanet.co.cc
	Or if you have several config files and prefer having only one command:
	/home/deanet/public_html/deanet.co.cc/awstats/tools/awstats_updateall.pl now
	Press ENTER to continue... '<- tekan enter'
	.
	.
	A SIMPLE config file has been created: /etc/awstats/awstats.deanet.co.cc.conf
	You should have a look inside to check and change manually main parameters.
	You can then manually update your statistics for 'deanet.co.cc' with command:
	> perl awstats.pl -update -config=deanet.co.cc
	You can also read your statistics for 'deanet.co.cc' with URL:
	> http://localhost/awstats/awstats.pl?config=deanet.co.cc
	.
	Press ENTER to finish.. '<- tekan enter'
	

##Configurasi nya:

1. edit file `/etc/awstats/awstats.deanet.co.cc.conf`

	{% highlight xml %}
	LogFile="/var/log/apache2/deanetc.access-log"
	DirData="/home/deanet/public_html/deanet.co.cc/awstats"
	SiteDomain="deanet.co.cc"
	AllowToUpdateStatsFromBrowser=1
	{% endhighlight %}

2. make sure log access apache file same as with Log File awstats :)

	{% highlight apacheconf %}
	<virtualHost deanet.co.cc:80>
        	ServerName deanet.co.cc
	        ServerAlias www.deanet.co.cc
	        DocumentRoot "/home/deanet/public_html/deanet.co.cc"
	        CustomLog "/var/log/apache2/deanetc.access-log" combined '<- here'
	        ErrorLog "/var/log/apache2/deanetc.error.log"
	        HostnameLookups Off
	        UseCanonicalname Off
        	ServerSignature Off
	        <directory "/home/deanet/public_html/deanet.co.cc">
	                Options All
	                AllowOverride None
	                Order allow,deny
                	Allow from All
	        </directory>
	</virtualHost>
	{% endhighlight %}

##Testing

Untuk test bisa langsung ke `http://server/awstats/awstats.pl?config=your-domain.com`

untuk update via console:

	wwwroot/cgi-bin # ./awstats.pl -config=deanet.co.cc -update


##Tips:

Awstats menudukung juga untuk membaca log berdasarkan hari, tanggal, bulan dan tahun. Hanya diperlukan kesamaan penamaan file log access saja dan install cronolog jangan lupa.

	#  wget http://cronolog.org/download/cronolog-1.6.2.tar.gz
	# ./configure
	# make && make install

lalu edit file `/etc/awstats/awstats.deanet.co.cc.conf`

	LogFile="/var/log/apache2/logs/%YYYY/%MM/%DD/deanetc.access-log"

dan `httpd.conf`

	CustomLog "|/usr/local/sbin/cronolog /var/log/apache2/%Y/%m/%d/deanetc.access.log" combined

selesai

semoga berguna :)

Referensi:

1. [heker86.wordpress.com](http://heker86.wordpress.com/2008/10/27/install-dan-kofigurasi-awstats)
2. [blackonsole.org](http://www.blackonsole.org/2009/05/configure-vhost-apache-on-opensuse-110.html)
