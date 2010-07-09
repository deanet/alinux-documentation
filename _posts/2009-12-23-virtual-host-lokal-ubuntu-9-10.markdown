--- 
layout: post
title: Virtual Host Lokal Ubuntu 9.10
date: 2009-12-23 23:12:00
---

Ok.. di keluarga debian, sudah diberi kemudahan dalam mengkonfigurasi apache server. Jadi kurang lebih di `/etc/apache` (tempat konfigurasi apache) ada directory seperti ini:

{% highlight xml %}
|-- sites-available
|   |-- default
|   |-- default-ssl
|   `-- sd
`-- sites-enabled
    |-- 000-default -> ../sites-available/default
    `-- sd -> ../sites-available/sd
{% endhighlight %}

Didalam directory `sites-available` terdapat file2 yang menunjukkan bahwa itu adalah file konfigurasi site/domain.
Misal:
1. default adalah untuk domainnya
isi file default:

{% highlight apacheconf %}
<VirtualHost *:80>
       	ServerAdmin webmaster@localhost
        ServerName nico.sd
        ServerAlias nico.sd
        DocumentRoot /var/www
        <Directory />
                Options FollowSymLinks
                AllowOverride All
        </Directory>
        <Directory /var/www/>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
        </Directory>
        ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
        <Directory "/usr/lib/cgi-bin">
                AllowOverride None
                Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                Order allow,deny
                Allow from all
        </Directory>
        ErrorLog /var/log/apache2/error.log
        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel warn
        CustomLog /var/log/apache2/access.log combined
    Alias /doc/ "/usr/share/doc/"
    <Directory "/usr/share/doc/">
        Options Indexes MultiViews FollowSymLinks
        AllowOverride None
        Order deny,allow
        Deny from all
        Allow from 127.0.0.0/255.0.0.0 ::1/128
    </Directory>
</VirtualHost>
{% endhighlight %}

Nah, bagaimana kita membuat virtual host baru ?? Untuk membuat vhost, tentunya harus bikin 1 lebih Document root nya. Yang default adalah untuk domainnya, sedangkan untuk vhost lain bisa kopi dari file default dengan perubahan seperlunya.
jadi:

	# cp default sd

terus ubah dengan seperlunya

 {% highlight apacheconf %}
 <VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName sd.nico.sd
        ServerAlias sd.nico.sd
        DocumentRoot /var/sd
        <Directory />
                Options FollowSymLinks
                AllowOverride All
        </Directory>
        <Directory /var/sd/>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
        </Directory>

        ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
        <Directory "/usr/lib/cgi-bin">
                AllowOverride None
                Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                Order allow,deny
                Allow from all
        </Directory>
        ErrorLog /var/log/apache2/error.log
        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel warn
        CustomLog /var/log/apache2/access.log combined
    Alias /doc/ "/usr/share/doc/"
    "Directory "/usr/share/doc/"
        Options Indexes MultiViews FollowSymLinks
        AllowOverride None
        Order deny,allow
        Deny from all
        Allow from 127.0.0.0/255.0.0.0 ::1/128
    </Directory>
</VirtualHost>
{% endhighlight %}

sampai di sini konfigurasi sudah selesai. Sekarang tinggal mengaktifkan site/vhost/domain yang akan diaktifkan.

	# a2ensite sd

Coba lihat didalam directory site-enabled, itu adalah domain2 yang sudah diaktifkan. Jika sudah restart apache

	# apache2ctl restart

Nah, untuk mengakses via w- machine tinggala menambahkan di `C:\W-\system32\drivers\etc\hosts`

misal ip ubuntu tadi : `172.16.0.155`

tambahkan dibawahnya:

	172.16.0.155 nico.sd
	172.16.0.155 sd.nico.sd

lalu akses lewat browser...


semoga bermanfaat :)

Referensi:
1. Google aj degh.. byk koq disitu :D
