---
layout: post
title: Install apache, php5, and mysql on FreeBSD 7.2 using ports  
date: 2009-06-17 17:00:06
---
  
## Update: 12/09/2009 {#update_12092009}

Apache web server one of the most widely used. Apache can also be installed on freebsd. following way to install apache, PHP5, mysql the most easy to use ports.

## 1. Install Apache: {#1_install_apache}

    # cd /usr/ports/www/apache22
    # make install clean

to start just type

    # /usr/local/sbin/apachectl start

to enable apache on boot add `apache22_enable="YES"` following file `/etc/rc.conf`

check apache on your browser type `localhost`

## 2. Install PHP 5 {#2_install_php_5}

    # /usr/ports/lang/php5
    # make install clean

make sure to build Apache module is `checked`

add these option on file `/usr/local/etc/apache22/httpd.conf`

    AddType application/x-httpd-php .php
    AddType application/x-httpd-php-source .phps

Add `Index.php` to load auto index

    <IfModule dir_module>
        DirectoryIndex index.html index.php
    </IfModule>

create file `php.ini` by copy `php.ini-dist`

    # cd /usr/local/etc/
    # cp php.ini-dist php.ini

and then `restart apache`

    # /usr/local/sbin/apachectl restart

create file php on `/usr/local/www/apache22/data/`

    <?php phpinfo();?>

save as `test.php`

now test on your browser `http://127.0.0.1/test.php`

## Install Mysql 5 {#install_mysql_5}

    # cd /usr/ports/databases/mysql51-server
    # make install clean

#### create database {#create_database}

    # /usr/local/bin/mysql_install_db

change `owner` and `group` as `mysql`

    # chown -R mysql /var/db/mysql/
    # chgrp -R mysql /var/db/mysql/

#### run mysql daemon {#run_mysql_daemon}

    /usr/local/bin/mysqld_safe user=mysql &;

#### change mysql password {#change_mysql_password}

    /usr/local/bin/mysqladmin -u root password newpass

to automatic msyql enable when boot add `/etc/rc.conf`:

    mysql_enable="YES";

#### Install php5-mysql module {#install_php5mysql_module}

    cd /usr/ports/databases/php5-mysql
    make install clean

create file php to check mysql

{% highlight php %}
    <?php
    $test=mysql_connect("localhost","mysql","";);
    if(!$test)                                                                 
    {                                                                          
    print "cant connect";                                            
    }                                                                          
    else                                                                       
    {                                                                          
    print "connected";                                               
    }                                                                          
    ?>

{% endhighlight %}

save as `test-db.php` on `/usr/local/www/apache22/data/` and go to your browser `http://localhost/test-db.php`

Reference:

1.  [mysql marksanborn.net][1]
2.  [apache marksanborn.net][2]
3.  [faruqafif.student.fkip.uns.ac.id][3]
4.  [daemonforums.org][4] 


 [1]: http://www.marksanborn.net/freebsd/installing-mysql-51-on-freebsd-70
 [2]: http://www.marksanborn.net/uncategorized/installing-apache-on-freebsd-70/comment-page-1/#comment-26351
 [3]: http://faruqafif.student.fkip.uns.ac.id/2009/02/13/install-apache2mysql-dan-php5-di-freebsd/
 [4]: http://daemonforums.org/showthread.php?t=1430
