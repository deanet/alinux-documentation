--- 
layout: post_new
title: Install Nginx 1.0.4 and PHP-FPM Patch 0.5.14
date: 2011-07-31 16:25:13
categories: 
- Nginx
- PHP
- FPM
- PHP-FPM
updated: 2011-07-31 16:42:08
---

Quick how to.

here we go...

##Install Nginx 1.0.4 version.

grab this code and execute it.

<script src="https://gist.github.com/1055952.js?file=nginx.sh" type="text/javascript">
</script>


##Install PHP and Patch FPM 0.5.14

grab this code and execute it.

<script src="https://gist.github.com/1055952.js?file=php-fpm-patch.sh" type="text/javascript">
</script>


##Configure PHP-FPM.conf

Grab this code and put as `/usr/local/php/etc/php-fpm.conf`.

<script src="https://gist.github.com/1055952.js?file=php-fpm.conf" type="text/javascript">
</script>


##Configure PHP.ini

we can use php.ini on <a href="https://gist.github.com/raw/1055952/e6c720170ef0d0771c2d75afb93a332ee2b9fbcb/php.ini" target="_new">this page</a>

##PHP-CGI Script

grab this code and run it..

<script src="https://gist.github.com/1055952.js?file=php-fpm.bash" type="text/javascript">
</script>

to make sure php-cgi run or not, just type `netstat -ntlp` or `lsof -i tcp:9000`.

hope this help.. ;)
