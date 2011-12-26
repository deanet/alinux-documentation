--- 
layout: post_new
title: Install PHP PostgreSQL Module and enable PostgreSQL Module Internal cPanel PHP on WHM
date: 2011-07-31 14:13:02
categories: 
- install
- PHP
- PostgreSQL
- cPanel
- WHM
updated: 2011-07-31 14:33:53
---


Well. That was make me annoying 1 month ago. Actually, if you run WHM. There are two version of PHP.

	1. PHP module run on client.
	2. PHP module run on internal WHM/cPanel.

On previous post, i was installing PostgreSQL on WHM. But client can't use it on PostgreSQL admin or their application. So, we just enable both of them.
<br/><br/>
Here we go..
<br/>

##Enable PostgreSQL module on internal cPanel PHP on WHM.


	1. Edit `/var/cpanel/easy/apache/profile/makecpphp.profile.yaml`

change value:

	`Cpanel::Easy::PHP5::Pgsql: 1`

run script:

	2. run `/scripts/makecpphp`



##Enable PostgreSQL module on PHP that run on user/client.

<script src="https://gist.github.com/1044069.js?file=install-php-postgresql-module" type="text/javascript">
</script>



ref: [http://bit.ly/j5D28I](http://bit.ly/j5D28I)
