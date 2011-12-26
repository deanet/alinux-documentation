--- 
layout: post_new
title: how to knowing sas hba on IBM Blade HS21 or HS22
date: 2011-04-16 21:08:45
categories: 
- IBM
- BLade
- SAS
- HBA
- HS21
- HS22
updated: 2011-04-16 21:27:44
---

##This is very simple how to knowing your sas (serial attach scsi) hba on your machine IBM BLade HS21 or HS22.

{% highlight xml %}
root@eptcadv4 ~# lsscsi 
0:0:0:0    disk    IBM-ESXS ST9300603SS      B53B  -       
0:0:1:0    disk    IBM-ESXS ST9300603SS      B53B  /dev/sda
0:1:1:0    disk    LSILOGIC Logical Volume   3000  /dev/sdb
2:0:0:0    disk    IBM      1818      FAStT  0730  -       
2:0:0:31   disk    IBM      Universal Xport  0730  -       
{% endhighlight %}


##with systool:

{% highlight xml %}
root@eptcadv4 ~# systool -c fc_host -v
Class = "fc_host"

  Class Device = "host1"
  Class Device path = "/sys/class/fc_host/host1"
    fabric_name         = "0x20000024ff2c7f9a"
    issue_lip           = store method only
    node_name           = "0x20000024ff2c7f9a"
    port_id             = "0x000000"
    port_name           = "0x21000024ff2c7f9a"
    port_state          = "Online"
    port_type           = "Unknown"
    speed               = "unknown"
    supported_classes   = "Class 3"
    supported_speeds    = "1 Gbit, 2 Gbit, 4 Gbit, 8 Gbit"
    symbolic_name       = "QMI2572 FW:v4.04.09 DVR:v8.03.01.04.05.05-k"
    system_hostname     = ""
    tgtid_bind_type     = "wwpn (World Wide Port Name)"
    uevent              = store method only

    Device = "host1"
    Device path = "/sys/devices/pci0000:00/0000:00:09.0/0000:24:00.0/host1"
      ct                  = 
      edc                 = store method only
      els                 = 
      fw_dump             = 
      nvram               = "ISP "
      optrom_ctl          = store method only
      optrom              = 
      reset               = store method only
      sfp                 = 
      uevent              = store method only
      vpd                 = "B"


  Class Device = "host2"
  Class Device path = "/sys/class/fc_host/host2"
    fabric_name         = "0x100000051eb22963"
    issue_lip           = store method only
    node_name           = "0x20000024ff2c7f9b"
    port_id             = "0x010f01"
    port_name           = "0x21000024ff2c7f9b"
    port_state          = "Online"
    port_type           = "NPort (fabric via point-to-point)"
    speed               = "4 Gbit"
    supported_classes   = "Class 3"
    supported_speeds    = "1 Gbit, 2 Gbit, 4 Gbit, 8 Gbit"
    symbolic_name       = "QMI2572 FW:v4.04.09 DVR:v8.03.01.04.05.05-k"
    system_hostname     = ""
    tgtid_bind_type     = "wwpn (World Wide Port Name)"
    uevent              = store method only

    Device = "host2"
    Device path = "/sys/devices/pci0000:00/0000:00:09.0/0000:24:00.1/host2"
      ct                  = 
      edc                 = store method only
      els                 = 
      fw_dump             = 
      nvram               = "ISP "
      optrom_ctl          = store method only
      optrom              = 
      reset               = store method only
      sfp                 = 
      uevent              = store method only
      vpd                 = "B"
{% endhighlight %}


{% highlight xml %}
root@eptcadv4 ~# systool -c fc_transport -v
Class = "fc_transport"

  Class Device = "0:0"
  Class Device path = "/sys/class/fc_transport/target2:0:0"
    node_name           = "0x200600a0b86e46f0"
    port_id             = "0x011500"
    port_name           = "0x201600a0b86e46f0"
    uevent              = store method only

    Device = "target2:0:0"
    Device path = "/sys/devices/pci0000:00/0000:00:09.0/0000:24:00.1/host2/rport-2:0-0/target2:0:0"
      uevent              = store method only
{% endhighlight %}



{% highlight xml %}
root@eptcadv4 ~# lspci |grep -i Qlogic
24:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI Express HBA (rev 02)
24:00.1 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI Express HBA (rev 02)
{% endhighlight %}
{% highlight xml %}
root@eptcadv4 ~# cat /sys/class/fc_host/host?/port_name
0x21000024ff2c7f9a
0x21000024ff2c7f9b
root@eptcadv4 ~# ls -l /sys/class/fc_host/host?/device
{% endhighlight %}
{% highlight xml %}
lrwxrwxrwx 1 root root 0 Mar  9 12:28 /sys/class/fc_host/host1/device -> ../../../devices/pci0000:00/0000:00:09.0/0000:24:00.0/host1
lrwxrwxrwx 1 root root 0 Mar  9 12:28 /sys/class/fc_host/host2/device -> ../../../devices/pci0000:00/0000:00:09.0/0000:24:00.1/host2
{% endhighlight %}
{% highlight ruby %}
root@eptcadv4 ~# ls -l /sys/block/(type_asterix_symbol_here)/device
lrwxrwxrwx 1 root root 0 Mar  9 12:28 /sys/block/sda/device -> ../../devices/pci0000:00/0000:00:01.0/0000:0b:00.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0
lrwxrwxrwx 1 root root 0 Mar  9 12:28 /sys/block/sdb/device -> ../../devices/pci0000:00/0000:00:01.0/0000:0b:00.0/host0/target0:1:1/0:1:1:0
{% endhighlight %}

look, after check on device, same as with below (left).
{% highlight xml %}
root@eptcadv4 ~# lsscsi 
0:0:0:0    disk    IBM-ESXS ST9300603SS      B53B  -       
0:0:1:0    disk    IBM-ESXS ST9300603SS      B53B  /dev/sda
0:1:1:0    disk    LSILOGIC Logical Volume   3000  /dev/sdb
2:0:0:0    disk    IBM      1818      FAStT  0730  -       
2:0:0:31   disk    IBM      Universal Xport  0730  -       
root@eptcadv4 ~# 
{% endhighlight %}

reference:
1. [http://www.linux-archive.org/device-mapper-development/405101-how-associate-pci-id-wwpn-hba.html](http://www.linux-archive.org/device-mapper-development/405101-how-associate-pci-id-wwpn-hba.html)
2. [http://forums11.itrc.hp.com/service/forums/questionanswer.do?admit=109447626+1299652342616+28353475&threadId=1386462](http://forums11.itrc.hp.com/service/forums/questionanswer.do?admit=109447626+1299652342616+28353475&threadId=1386462)
