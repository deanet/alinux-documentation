--- 
layout: post_new
title: Install rrdtool 1.4.5 on Linux machine
date: 2011-07-31 16:40:27
categories: 
- install
- Rrd
- RRDtool
---

##Installing Dependencies

Pixman.
{% highlight bash %}
wget -c http://oss.oetiker.ch/rrdtool/pub/libs/pixman-0.10.0.tar.gz
tar -xvf pixman-0.10.0.tar.gz
cd pixman-0.10.0
./configure
make
make install
{% endhighlight %}


Cairo.
{% highlight bash %}
wget -c http://oss.oetiker.ch/rrdtool/pub/libs/cairo-1.6.4.tar.gz
tar -xvf cairo-1.6.4.tar.gz
cd cairo-1.6.4
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/pkgconfig
./configure
make
make install
{% endhighlight %}


if got error:
{% highlight bash %}

error: pixman> = 0.10.0 d
{% endhighlight %}

install pixman first.


Glib.

{% highlight bash %}

wget -c http://oss.oetiker.ch/rrdtool/pub/libs/glib-2.15.4.tar.gz
tar -xvf glib-2.15.4.tar.gz
cd glib-2.15.4
./configure --prefix=/usr/local/glib
make
make install
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:/usr/local/glib/lib/pkgconfig/
{% endhighlight %}


Pango.

{% highlight bash %}

wget -c http://oss.oetiker.ch/rrdtool/pub/libs/pango-1.21.1.tar.bz2
tar -xvf pango-1.21.1.tar.bz2
cd pango-1.21.1
./configure
make
make install
{% endhighlight %}




##install RRDTOOL 1.4.5

{% highlight bash %}
wget -c http://oss.oetiker.ch/rrdtool/pub/rrdtool-1.4.5.tar.gz
tar -xvf rrdtool-1.4.5.tar.gz
cd rrdtool-1.4.5
./configure --prefix=/usr/local/rrdtool
make
make install

[root@mrtg rrdtool-1.4.5]# /usr/local/rrdtool/bin/rrdtool -v
RRDtool 1.4.5 Copyright 1997-2010 by Tobias Oetiker <tobi@oetiker.ch>
               Compiled Jun 30 2011 09:04:17

Usage: rrdtool [options] command command_options
Valid commands: create, update, updatev, graph, graphv, dump, restore,
last, lastupdate, first, info, fetch, tune,
resize, xport, flushcached

RRDtool is distributed under the Terms of the GNU General
Public License Version 2. (www.gnu.org/copyleft/gpl.html)

For more information read the RRD manpages

[root@mrtg rrdtool-1.4.5]#
{% endhighlight %}

ref: [http://xinet.kr/tc/89?category=0](http://xinet.kr/tc/89?category=0)
