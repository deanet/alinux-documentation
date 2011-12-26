--- 
layout: post_new
title: Make USB installer OpenBSD 4.8
categories: [USB, installer, OpenBSD]
date: 2010-10-04 21:45:18
---
  
###Prelude:

  Hey bro,
  See you again. Well, this time very hard to say. Truly i wanna turn off this site, also maintenance of site. I'm very bored at this time
flying, surfing, browsing on cyber worlds. Along time i've graduated from high school,i'm knew very well cyber worlds. Time by time..
  K, i;m just say getting back to my way.. not usually way.. the way for this documentation..

  Yesterday i was trying bootable OpenBSD using grub, but just nothing that i've got.. `unknown partition`. Just got an idea from
`liveusb-openbsd.sourceforge.net`, i've successfully made `usb pendrive` boot with self of OpenBSD. So, it;s very simple and protable. 
<center>
<a href="http://farm5.static.flickr.com/4133/5051351018_1704e592a9_b.jpg" target="_new"><img src="http://farm5.static.flickr.com/4133/5051351018_1704e592a9.jpg" border="0"></a>
</center>

###Take d0wn
  So, how to make bootable OpenBSD installer on `usb pendrive` ?.

  This is simple way what i've did my self.
  To take this, you need:

  1. Create your own LiveUSB with OpenBSD. Read: [http://liveusb-openbsd.sourceforge.net](http://liveusb-openbsd.sourceforge.net). <br/>
  2. Boot your `usb pendrive`. then:<br/>

Identified your disk:
{% highlight xml %}  
# sysctl hw.disknames
{% endhighlight xml %}

Mount:
{% highlight xml %}  
# mount wd0a /
{% endhighlight xml %}

  2. Mount of iso OpenBSD to temporary place and copy them to `usb pendrive`.

{% highlight xml %}  
# mkdir /tmp/OpenBSD
# mount /path/your/iso/install48.iso /tmp/OpenBSD/ -o loop
# cp -a /tmp/OpenBSD/* /
{% endhighlight xml %}

  4. Reboot, done

  
  `Note`:
  `you need ext2 fs or ufs or ffs to place iso file install48.iso`
  `you can do all that steps use qemu without reboot your machine`
  `verify your bootable installer usb by qemu -usb -hda /dev/sdd`

  you might read nice article: [http://www.azbsd.org/~marco/openbsd/flashkeyinstaller](http://www.azbsd.org/~marco/openbsd/flashkeyinstaller)

  Oh.. i must get some sleep now.. it's 10:08 PM ..

  Reference:
  1. [http://liveusb-openbsd.sourceforge.net/](http://liveusb-openbsd.sourceforge.net/)

