--- 
layout: post_new
title: Custom Screensaver with xprintidle
categories: [c0ding, bash, scripting, xprintidle, gnome, screensaver]
date: 2012-05-2 07:37
---

xprintidle is a small program that prints the user's idle time to stdout, using the X screensaver extension. It is meant for use in scripts. Other, xprintidle is a utility that queries the X server for the user's idle time and prints it to stdout (in milliseconds). 


##Install xprintidle

grab `deb package` from [here](http://packages.debian.org/sid/xprintidle). Make sure distribution match your debian version. Or grab the [source](http://packages.debian.org/source/sid/xprintidle)



##Scripting


{% highlight bash %}
#!/bin/bash

while [ 1 ];
do
if [ `xprintidle` -gt 60000 ];
then

gnome-screensaver-command -l

fi
sleep 1
done

{% endhighlight %}

save as screensaver.sh, and run it. After 60 seconds idle time, gnome-screensaver will run and lock the desktop.


reference:
[alex.ballas.org](http://alex.ballas.org/tag/xprintidle/)
