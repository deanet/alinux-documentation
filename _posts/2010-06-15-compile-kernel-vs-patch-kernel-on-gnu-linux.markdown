--- 
layout: post
title: Compile Kernel VS Patch Kernel on Gnu/Linux
date: 2010-06-15 19:43:06
---

2 years ago first time i'm playing with compile kernel, no documented of the one as well. And some months ago i've been stuck with bluetooth device. Since i've upgrade my kernel Slackware to be 2.6.33, bluetooth device cannot scaning device correctly. Then i try to rollback with old kernel, bom ! .. scanning succesfuly results of other bluetooth device. Now, i've two option: compile same kernel again and enable hci bluetooth driver, or compile with highest kernel using source or patching kernel to get highest kernel version :).

##Compile Kernel.

Upgrade kernel via compail kernel used when you need new `modules` of hardware which can't detect on your current kernel. So, to upgrade kernel via compail kernel, you just get new version kernel, compail the module kernel, and reboot. One thing when you reboot and you got `kernel panic`, you could rollback using old kernel backup. 

##Patch Kernel

Patch kernel used when you found bug of your module as used or to upgrade your current kernel into highest kernel. Best practice patching kernel needed which you don't download all of source kernel to update your version kernel or keep update of kernel bugs. See difference of patch release bug on changelog file.


on with conditions, when you need upgrade kernel, you must choose efective option. an example:

1. My current kernel is `2.6.29.6`
2. I want to upgrading kernel into highest kernel ( example `2.6.35-rc3`)
3. I've source kernel `2.6.34` as before.

So, there are many ways:

1. Get source linux kernel `2.6.35-rc3`, and compile it.
2. Get patch file `2.6.35-rc3` and apply on source kernel `2.6.34`, and compile it.
3. Patch source current kernel using:
- `patch file 2.6.29.6`
- then using `patch file 2.6.30`
- `patch file 2.6.31`
- `patch file 2.6.32`
- `patch file 2.6.33`
- `patch file 2.6.34`
- `patch file 2.6.35-rc3`

So, because i've source kernel `2.6.34`, i'm just only need patch `2.6.35-rc3`:



before:
{% highlight bash %}
root@darkstar:/usr/src/linux# uname -a
Linux darkstar 2.6.29.6-smp #2 SMP Mon Aug 17 00:52:54 CDT 2009 i686 Intel(R) Core(TM)2 Duo CPU     T7100  @ 1.80GHz GenuineIntel
GNU/Linux
root@darkstar:/usr/src/linux#
{% endhighlight %}


after:

{% highlight bash %}
root@darkstar:/usr/src/linux# uname -a
Linux ajisaka 2.6.35-rc3rajab #2 SMP PREEMPT Sun Jun 13 22:08:59 WIT 2010 i686 Intel(R) Core(TM)2 Duo CPU     T7100  @ 1.80GHz
GenuineIntel GNU/Linux
root@darkstar:/usr/src/linux# 
{% endhighlight %}


##update
`19 Juni 2010`

##citsit step compail kernel

- `make dep`
- `make clean`
- `make menuconfig`
- `make`
- `make bzImage`
- `make modules`
- `make modules_install`
- `make install`

cause i've found bug of `prtscr` and `pause break` keys which make `kernel panic` :))

#Your own risk && please dont use rc(release candidat) version unless you know what are u doing

hereis logfile

{% highlight bash %}
Jun 17 21:03:45 ajisaka kernel: SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J
) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T
) Unmount show-blocked-tasks(W)
{% endhighlight %}

now, i must downgrade kernel, but i lazy boy .. ;p
i was using travelmate 6292 running on slackware with <a href="/files/config" target="_new">custom config kernel</a>.


semoga bermanfaat :)
