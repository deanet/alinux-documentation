--- 
layout: post
title: Limited Upload max on your own directory apache
date: 2010-04-28 04:00:04
---
`Apache` is one powerfull web server most used on cyber world. So many module to configuring as you want. One of them called `mod_php`. Sometimes we need different value of php main configuration. An example, on `php main configuration` we've added `upload max 5M`. So, you want a directory have different to upload more 5 M, example: 100M. So just `add` to your own directory directive:

{% highlight apacheconf %}
<Directory /usr/local/www/upload>
php_value upload_max_filesize 100M
php_value post_max_size 100M
php_value max_execution_time 200
php_value max_input_time 200
</Directory>
{% endhighlight %}
semoga membantu.. :)

ref:
<a href="http://php.net/manual/en/configuration.changes.php" target="_blank">
http://php.net/manual/en/configuration.changes.php
</a>
