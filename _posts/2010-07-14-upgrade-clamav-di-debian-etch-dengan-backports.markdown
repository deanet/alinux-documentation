--- 
layout: post
title: Upgrade ClamAV di Debian Etch dengan backports
date: 2010-07-14 10:52:53
---

Bermula dari ketidakberesan `clamdscan` membuat `simscan` tidak berjalan sebagaimana mestinya. Usul usul punya usul ternyata setelah
dicek memang benar `clamdscan` tidak berjalan secara normal.                                                                        

{% highlight xml %}
denbaguse:/home/deanet# clamdscan mailtest.txt 
connect(): No such file or directory           
WARNING: Can't connect to clamd.               

----------- SCAN SUMMARY -----------
Infected files: 0                   
Time: 0.001 sec (0 m 0 s)           
denbaguse:/home/deanet#             
{% endhighlight %}


Setelah dipusingkan dengan beberapa daemon dan proses. Alhasil dicek di configurasi nya `/etc/clamav/clamd.conf`. Dan stelah dicek
beberapa `pid` ternyata ada yang janggal.                                                                                         
                                                                                                                                  
{% highlight xml %}
denbaguse:/home/deanet# ls -al /var/run/clamav/                                                                                   
total 12                                                                                                                          
drwxr-xr-x 2 clamav clamav 4096 2010-06-21 12:15 .                                                                                
drwxr-xr-x 9 root   root   4096 2010-06-19 09:30 ..                                                                               
-rw-rw---- 1 clamav clamav    5 2010-06-21 12:15 freshclam.pid                                                                    
{% endhighlight %}

Lha??? kemana `pid` dari `clamav-daemon` ? 

Menyelidiki kasus tersebut


{% highlight xml %}
denbaguse:/home/deanet# dpkg -l clamav                        
Desired=Unknown/Install/Remove/Purge/Hold                     
| Status=Not/Installed/Config-files/Unpacked/Failed-config/Half-installed
|/ Err?=(none)/Hold/Reinst-required/X=both-problems (Status,Err: uppercase=bad)
||/ Name                Version             Description                        
+++-===================-===================-======================================================
ii  clamav              0.90.1dfsg-4etch19  antivirus scanner for Unix                            
{% endhighlight %}

Ternyata versi nya sudah sangat old. tambahkan repository list `backports`:

{% highlight xml %}
denbaguse:/home/deanet# vim /etc/apt/sources.list
{% endhighlight %}

Update repo,

{% highlight xml %}
denbaguse:/home/deanet# apt-get update
Get:1 http://backports.mithril-linux.org etch-backports Release.gpg [189B]
Get:2 http://backports.mithril-linux.org etch-backports Release [72.9kB]
Get:3 http://backports.mithril-linux.org etch-backports/main Packages [561kB]
Get:4 http://backports.mithril-linux.org etch-backports/contrib Packages [2631B]
Get:5 http://backports.mithril-linux.org etch-backports/non-free Packages [5785B]
Fetched 643kB in 43s (14.9kB/s)
Reading package lists... Done
denbaguse:/home/deanet#
{% endhighlight %}

Jalankan untuk upgrade clamAV
{% highlight xml %}
apt-get upgrade clamav clamav-daemon clamav-freshclam
{% endhighlight %}

Test:

{% highlight xml %}
denbaguse:/home/deanet# clamdscan mailtest.txt
/home/deanet/mailtest.txt: OK

----------- SCAN SUMMARY -----------
Infected files: 0
Time: 0.251 sec (0 m 0 s)
denbaguse:/home/deanet# ls -al /var/run/clamav/
total 16
drwxr-xr-x 2 clamav clamav 4096 2010-06-21 13:21 .
drwxr-xr-x 9 root   root   4096 2010-06-21 13:20 ..
srwxrwxrwx 1 clamav clamav    0 2010-06-21 13:21 clamd.ctl
-rw-rw-r-- 1 clamav clamav    5 2010-06-21 13:21 clamd.pid
-rw-rw-r-- 1 clamav clamav    5 2010-06-21 13:35 freshclam.pid
denbaguse:/home/deanet#
{% endhighlight %}


semoga membantu :)
