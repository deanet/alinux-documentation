---
title: php ini not working on cPanel use suPHP
layout: post_new
categories: 
- PHP
- cPanel
- suPHP
---

is suPHP apache trouble maker which php.ini on per user not working as well.

<script src="https://gist.github.com/1433829.js?file=optsuphpetcsuphp.conf" type="text/javascript">
</script>

and check now

<pre class="terminal bootcamp">
<span class="codeline">root@venus [/home/rottwe/www]# php -c php.ini t.php | grep global<span>run command</span></span>
<span class="bash-output">auto_globals_jit => On => On</span>
<span class="bash-output">register_globals => On => On</span>
</pre>


reference
[whmcpanel-per-user-php-ini-under-apache-2-x-and-suphp](http://www.sant-media.co.uk/2010/02/whmcpanel-per-user-php-ini-under-apache-2-x-and-suphp/)



