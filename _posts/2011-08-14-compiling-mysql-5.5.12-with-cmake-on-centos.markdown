--- 
layout: post_new
title: Compiling MySQL 5.5.12 with CMAKE on CentOS
date: 2011-08-14 12:57:57
categories: 
- Compile
- MySQL
- CMAKE
- CentOs
---


##Install dependencies package

{% highlight bash %}
yum install -y cmake.x86_64 gcc44-gfortran-4.4.4-13.el5 gcc-objc++-4.1.2-50.el5 gcc-4.1.2-50.el5 gcc44-4.4.4-13.el5 libgcc-4.1.2-50.el5 gcc44-c++-4.4.4-13.el5 gcc-c++-4.1.2-50.el5 gcc-gfortran.x86_64 ncurses-devel.x86_64 bison-devel.x86_64
{% endhighlight %}


##Getting source and cmake

{% highlight bash %}
wget -c http://ftp.jaist.ac.jp/pub/mysql/Downloads/MySQL-5.5/mysql-5.5.12.tar.gz
tar -xvf mysql-5.5.12.tar.gz
cd mysql-5.5.12

cmake . -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/mysql -DENABLE_DEBUG_SYNC:BOOL=OFF -DMYSQL_DATADIR:PATH=/home/mysql -DMYSQL_DATADIR=/usr/local/mysql/data -DSYSCONFDIR=/usr/local/mysql -DMYSQL_UNIX_ADDR:FILE_NAME=/usr/local/mysql/tmp/mysql.sock -DWITH_EMBEDDED_SERVER:BOOL=ON -DWITH_EXTRA_CHARSETS:STRING=all
{% endhighlight %}


##Make and make install

{% highlight bash %}
make;
make install
groupadd mysql
useradd -r -g mysql mysql
cd /usr/local/mysql/
chgrp -R mysql .
chown -R mysql data
touch /var/log/mysqld.log;
touch /var/log/mysql/mysql-slow.log
mkdir /home/mysql;
mkdir /var/log/mysql;
chown mysql.mysql -Rf /var/log/mysqld.log /home/mysql /var/log/mysql
{% endhighlight %}


##My.cnf Configuration

{% highlight bash %}
vi /etc/my.cnf
{% endhighlight %}

<script src="https://gist.github.com/1144636.js?file=my.cnf" type="text/javascript">
</script>


##Run daemon

{% highlight bash %}
scripts/mysql_install_db --user=mysql
./bin/mysqld_safe &
./bin/mysql_secure_installation



110511 10:37:27 mysqld_safe Starting mysqld daemon with databases from /home/mysql/
110511 10:37:27 InnoDB: The InnoDB memory heap is disabled
110511 10:37:27 InnoDB: Mutexes and rw_locks use GCC atomic builtins
110511 10:37:27 InnoDB: Compressed tables use zlib 1.2.3
110511 10:37:27 InnoDB: Initializing buffer pool, size = 128.0M
110511 10:37:27 InnoDB: Completed initialization of buffer pool
110511 10:37:27 InnoDB: highest supported file format is Barracuda.
InnoDB: The log sequence number in ibdata files does not match
InnoDB: the log sequence number in the ib_logfiles!
110511 10:37:27  InnoDB: Database was not shut down normally!
InnoDB: Starting crash recovery.
InnoDB: Reading tablespace information from the .ibd files...
InnoDB: Restoring possible half-written data pages from the doublewrite
InnoDB: buffer...
110511 10:37:27  InnoDB: Waiting for the background threads to start
110511 10:37:28 InnoDB: 1.1.6 started; log sequence number 1595685
110511 10:37:28 [Note] Event Scheduler: Loaded 0 events
110511 10:37:28 [Note] /usr/local/mysql/bin/mysqld: ready for connections.
Version: '5.5.12-log'  socket: '/usr/local/mysql/tmp/mysql.sock'  port: 3306  Source distribution
{% endhighlight %}


Reference:

1. [http://www.geeksww.com/tutorials/database_management_systems/mysql/configuration/initializing_mysql_database_after_installation.php](http://www.geeksww.com/tutorials/database_management_systems/mysql/configuration/initializing_mysql_database_after_installation.php)
2. [http://forge.mysql.com/wiki/Autotools_to_CMake_Transition_Guide](http://forge.mysql.com/wiki/Autotools_to_CMake_Transition_Guide)
3. [http://www.howtoforge.com/installing-nginx-with-php5-and-mysql-support-on-centos-5.5-p2](http://www.howtoforge.com/installing-nginx-with-php5-and-mysql-support-on-centos-5.5-p2)

