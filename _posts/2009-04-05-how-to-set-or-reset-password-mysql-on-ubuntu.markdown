--- 
layout: post
title: How to set or reset password mysql on Ubuntu
date: 2009-04-05 05:00:16
---

I've was succesfully install mysql on my friends machine :) . After do that i need set new password for replace balnk passsword. This post is tiny psoting. So, this not recommanded for advanced user :lol: . ok. sometimes, after fresh installation i use command like this to set new password root on mysql.

	mysqladmin  -u root password newpassword

but it doesn't work. I've got some error message:

	mysqladmin: connect to server at 'localhost' failed
	error: 'Access denied for user 'root'@'localhost' (using password: NO)'

Try to recover, so i need to stop mysql daemon

	sudo /etc/rc5.d/S19mysql stop

then start mysql daemon again with skip grant tables and netwoking:

	sudo mysqld --skip-grant-tables --skip-networking

now, mysql daemon running with skip grant tables and networking. we can login without password :lol:

	mysql -u root

then, update for new password

	mysql> update mysql.user set password=password('toor') where user='root';

don't forget to flush privilages ;)

	mysql> flush privileges;

type quit and try again to login without password

	mysql> quit
	Bye

.
	
	{% highlight bash %}
	[zie: ]$ mysql -u root
	ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)
	[zie: ]$
	{% endhighlight %}

it's work ;) ..

some loggs can be see on [here](http://pastebin.com/f7a4d9222) and [here](http://pastebin.com/f6959257e)

Thanks to:

zie, for the machine :D

## Reference:

1. [Ubuntu help](https://help.ubuntu.com/community/MysqlPasswordReset)
