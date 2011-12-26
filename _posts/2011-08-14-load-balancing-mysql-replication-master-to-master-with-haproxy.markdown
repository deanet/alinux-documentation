--- 
layout: post_new
title: Load Balancing MySQL Replication Master to Master with HAProxy
date: 2011-08-17 16:44:52
categories: 
- Load Balance
- MySQL
- Replication
- HAProxy
---

##Quick How to Load Balancing MySQL master to master with HAProxy

On <a href="/2011/08/16/replicate-master-to-master-mysql.html">previous post</a>, we've installed MySQL Server Replication Master to Master. Now, we can do that for Load Balancing with HAProxy. We need one server again to do this.

Do this section on HAProxy server (on example).


###Installing HAProxy

{% highlight bash %}
wget -c http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.15.tar.gz
tar -xvf haproxy-1.4.15.tar.gz 
cd haproxy-1.4.15
make install
vim /usr/local/etc/haproxy.cfg
{% endhighlight %}


###Configuring HAProxy

<script src="https://gist.github.com/1144737.js?file=haproxy.cfg" type="text/javascript">
</script>


Do this section on srv14 (or master 1).

##Create mysql service on xinetd
<script src="https://gist.github.com/1144737.js?file=opt.mysqlchk.bash" type="text/javascript">
</script>

##Create MySQL Script to check mysql server is healthy running on localhost
<script src="https://gist.github.com/1144737.js?file=xinetd.mysqlchk.sh" type="text/javascript">
</script>



##Make sure mysqlchk is allowed as xinet services

{% highlight bash %}
root@srv14 src# cat /etc/services | grep 9200
#wap-wsp		9200/tcp			# WAP connectionless session service
wap-wsp		9200/udp			# WAP connectionless session service
mysqlchk	9200/tcp			# mysqlchk
{% endhighlight %}

## Create user mysqlchkuser and give grant.
<script src="https://gist.github.com/1144737.js?file=create-user.sql" type="text/javascript">
</script>


Do this section on srv15 (or master 2).

##Create mysql service on xinetd
<script src="https://gist.github.com/1144737.js?file=opt.mysqlchk.bash" type="text/javascript">
</script>

##Create MySQL Script to check mysql server is healthy running on localhost
<script src="https://gist.github.com/1144737.js?file=xinetd.mysqlchk.sh" type="text/javascript">
</script>

##Make sure mysqlchk is allowed as xinet services

{% highlight bash %}
root@srv15 ~# cat /etc/services | grep 9200
#wap-wsp		9200/tcp			# WAP connectionless session service
wap-wsp		9200/udp			# WAP connectionless session service
mysqlchk	9200/tcp
{% endhighlight %}


## Create user mysqlchkuser and give grant.

<script src="https://gist.github.com/1144737.js?file=create-user.sql" type="text/javascript">
</script>


##Give permission 777 for `/tmp/mysqlchk.*`

{% highlight bash %}
# chmod 777 /tmp/mysqlchk.*
{% endhighlight %}


## RUN HAProxy now


{% highlight bash %}
# /usr/local/sbin/haproxy -f /usr/local/etc/haproxy.cfg -p /var/run/haproxy.pid
{% endhighlight %}


## at Last

We can use port 3306 as `master` of Load Balancer. Look at `http://ip-load-balancer:31337` to monitor service both of them servers.

.
.
.
##Troubleshoot

###check mysql on localhost

{% highlight bash %}
root@srv14 src# /opt/mysqlchk 
HTTP/1.1 200 OK

Content-Type: Content-Type: text/plain



MySQL is running.



root@srv14 src# 
root@srv15 ~# /opt/mysqlchk 
HTTP/1.1 200 OK

Content-Type: Content-Type: text/plain



MySQL is running.



root@srv15 ~# 
{% endhighlight %}



###Check mysql service from HAProxy Server

{% highlight bash %}
root@master mysql# telnet 111.68.112.43 9200
Trying 111.68.112.43...
Connected to 111.68.112.43.
Escape character is '^]'.
HTTP/1.1 200 OK

Content-Type: Content-Type: text/plain



MySQL is running.



Connection closed by foreign host.
root@master mysql# telnet 111.68.112.44 9200
Trying 111.68.112.44...
Connected to 111.68.112.44.
Escape character is '^]'.
HTTP/1.1 200 OK

Content-Type: Content-Type: text/plain



MySQL is running.



Connection closed by foreign host.
root@master mysql# 
{% endhighlight %}



##Addtional Section

###MySQL Configuration File
###Master 1
<script src="https://gist.github.com/1144737.js?file=haproxy.m1-mysql.cnf" type="text/javascript">
</script>

###Master 2
<script src="https://gist.github.com/1144737.js?file=haproxy.m2-mysql.cnf" type="text/javascript">
</script>

Reference:

1. [http://www.dancryer.com/2010/01/load-balancing-mysql-with-ha-proxy](http://www.dancryer.com/2010/01/load-balancing-mysql-with-ha-proxy)
2. [http://andyleonard.com/2011/02/01/haproxy-and-keepalived-example-configuration/](http://andyleonard.com/2011/02/01/haproxy-and-keepalived-example-configuration/)
3. [http://blog.loadbalancer.org/configure-haproxy-with-tproxy-kernel-for-full-transparent-proxy/](http://blog.loadbalancer.org/configure-haproxy-with-tproxy-kernel-for-full-transparent-proxy/)
4. [http://blog.loadbalancer.org/ec2-load-balancer-appliance-rocks-and-its-free-for-now-anyway/](http://blog.loadbalancer.org/ec2-load-balancer-appliance-rocks-and-its-free-for-now-anyway/)
5. [http://agiletesting.blogspot.com/2010/02/use-haproxy-14-if-you-need-mysql-health.html](http://agiletesting.blogspot.com/2010/02/use-haproxy-14-if-you-need-mysql-health.html)
6. [http://www.cowboycoded.com/2009/08/17/mysql-haproxy-tutorial/](http://www.cowboycoded.com/2009/08/17/mysql-haproxy-tutorial/)
7. [http://sysbible.org/2008/12/04/having-haproxy-check-mysql-status-through-a-xinetd-script/](http://sysbible.org/2008/12/04/having-haproxy-check-mysql-status-through-a-xinetd-script/)
8. [http://www.tritux.com/blog/2010/11/19/partitioning-mysql-database-with-high-load-solutions/11/1](http://www.tritux.com/blog/2010/11/19/partitioning-mysql-database-with-high-load-solutions/11/1)
