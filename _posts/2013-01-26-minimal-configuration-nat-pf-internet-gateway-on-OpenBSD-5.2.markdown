---
title: Minimal Configuration NAT PF Internet Gateway on OpenBSD 5.2
layout: post_new
categories: 
- OpenBSD
- PF
- NAT
---


{% highlight bash %}
ext_if = "rl0" # macro for external interface - use tun0 for PPPoE
int_if = "bge0"  # macro for internal interface
int_net = "192.168.2.0/24"

pass out on $ext_if from $int_if:network to any nat-to ($ext_if)

{% endhighlight %}
