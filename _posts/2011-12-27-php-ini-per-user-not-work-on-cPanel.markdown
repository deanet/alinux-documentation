---
title: php ini not working on cPanel use suPHP
layout: post_new
categories: 
- php
- cPanel
- suPHP
---

is suPHP apache trouble maker which php.ini on per user not working as well.

<script src="https://gist.github.com/1433829.js?file=optsuphpetcsuphp.conf" type="text/javascript">
</script>

and check now

{% highlight bash %}
root@venus [/home/rottwe/www]# php -c php.ini t.php | grep global
auto_globals_jit => On => On
register_globals => On => On
root@venus [/home/rottwe/www]#
{% endhighlight %}


[reference](http://www.sant-media.co.uk/2010/02/whmcpanel-per-user-php-ini-under-apache-2-x-and-suphp/)



