--- 
layout: post
title: How to protect your page using mod authz host
date: 2010-04-04 04:04:04
---
Pada posting sekarang akan menjelaskan secara sederhana bagaimana menambahkan proteksi pada directory tertentu dengan module apache mod authz host. berdasarkan ip address Hanya menambahkan opsi dibawah ini pada konfigurasi apache `http.conf` atau `apache2.conf` pada bracket directory.

opsi:
{% highlight apacheconf %}
Order Deny,Allow
Deny from All
Allow from 172.16.0.0/23
{% endhighlight %}

ditambahkan pada directory `/usr/local/www/file/software` misalnya. Jadi konfigurasi lengkapnya:

{% highlight apacheconf %}
<Directory /usr/local/www/file/software>
     Order Deny,Allow
     Deny from All
     Allow from 172.16.0.0/23
</Directory>
{% endhighlight %}

Maksud dari opsi diatas adalah:

`Order deny,allow` : pengurutan opsi `deny` dan `allow` dari acl. Jadi maksudna deny dahulu baru diallow.<br/>
`Deny from All` : Gagalkan semua.<br/>
`Allow from IP` : Ijinkan dari IP.<br/>

kurang lebih begitu.

Semoga bermanfaat :)

ref:

<http://httpd.apache.org/docs/2.2/mod/mod_authz_host.html>
