---
title: Install KVM Virtualization on Debian Squeeze
layout: post_new
categories: [Debian, KVM, Virtualization]
date: 2010-12-20 19:26:04
---
  
##Understanding:

KVM (for Kernel-based Virtual Machine) is a full virtualization solution for Linux on x86 hardware containing virtualization extensions (Intel VT or AMD-V). It consists of a loadable kernel module, kvm.ko, that provides the core virtualization infrastructure and a processor specific module, kvm-intel.ko or kvm-amd.ko. KVM also requires a modified QEMU although work is underway to get the required changes upstream.

Using KVM, one can run multiple virtual machines running unmodified Linux or Windows images. Each virtual machine has private virtualized hardware: a network card, disk, graphics adapter, etc.

The kernel component of `KVM` is included in mainline Linux, as of 2.6.20. 
<br/><br/>
{% highlight bash %}
alinux@squeeze:~$ uname -a;cat /etc/debian_version 
Linux squeeze 2.6.36-21-DzulQaidah-1431H #4 SMP Sun Oct 31 06:31:57 WIT 2010 i686 GNU/Linux
squeeze/sid
alinux@squeeze:~$ 
{% endhighlight %}

##Requirements:
1. qemu-kvm
2. qemu
3. xvnc4viewer
<br/>
<br/>

##Installing:
Install by command:
{% highlight xml %}
apt-get install qemu-kvm qemu qemu-gl qemu-system qemu-user qemu-utils xvnc4viewer
{% endhighlight %}



##Check:
Need to check module of kvm was there or not, as well your Processor.

{% highlight bash %}
alinux@squeeze:~$ lsmod | grep kvm
kvm_intel              34767  0 
kvm                   186549  1 kvm_intel
alinux@squeeze:~$ egrep '^flags.*(vmx|svm)' /proc/cpuinfo
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts tpr_shadow vnmi flexpriority
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts tpr_shadow vnmi flexpriority
alinux@squeeze:~$ 
{% endhighlight %}

##Test with qemu

{% highlight bash %}
qemu -vnc localhost:5901 -enable-kvm -cdrom /home/ISO/CentOS-5.5-x86_64-bin-DVD-1of2.iso
{% endhighlight %}

##Let's go

{% highlight bash %}
alinux@squeeze:~$ sudo netstat -ntlp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      1574/mysqld     
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      1242/lighttpd   
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1254/sshd       
tcp6       0      0 :::80                   :::*                    LISTEN      1242/lighttpd   
tcp6       0      0 :::22                   :::*                    LISTEN      1254/sshd       
tcp6       0      0 ::1:11801               :::*                    LISTEN      3991/qemu       
alinux@squeeze:~$ xvncviewer localhost:11801

VNC Viewer Free Edition 4.1.1 for X - built Mar 10 2010 21:40:13
Copyright (C) 2002-2005 RealVNC Ltd.
See http://www.realvnc.com for information on VNC.

Mon Dec 20 20:00:25 2010
 CConn:       connected to host localhost port 11801
 CConnection: Server supports RFB protocol version 3.8
 CConnection: Using RFB protocol version 3.8
 TXImage:     Using default colormap and visual, TrueColor, depth 24.
 CConn:       Using pixel format depth 6 (8bpp) rgb222
 CConn:       Using ZRLE encoding
 CConn:       Throughput 20020 kbit/s - changing to hextile encoding
 CConn:       Throughput 20020 kbit/s - changing to full colour
 CConn:       Using pixel format depth 24 (32bpp) little-endian rgb888
 CConn:       Using hextile encoding
alinux@squeeze:~$ 
{% endhighlight %}

<center>
<a href="http://farm6.static.flickr.com/5086/5276722381_3459374304_b.jpg" target="_new"><img src="http://farm6.static.flickr.com/5086/5276722381_3459374304.jpg" border="0"></a>
</center>

have a nice dream ;)


  Reference:
  1. [http://www.linux-kvm.org/page/Main_Page](http://www.linux-kvm.org/page/Main_Page)

