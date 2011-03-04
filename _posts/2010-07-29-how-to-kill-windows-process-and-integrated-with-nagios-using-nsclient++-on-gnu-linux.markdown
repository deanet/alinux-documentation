---
layout: post_new
title: How to kill windows process and integrated with nagios using Nsclient++ on Gnu/Linux
categories: [kill, windows, nagios, Nsclient++, c0ding]
date: 2010-07-29 00:00:00
---

`Nagios` : a powerful monitoring system that enables organizations to identify and resolve IT infrastructure problems before they affect
critical business processes.

`NRPE addon for Nagios` : an addon that allows you to execute plugins on remote Linux/Unix hosts. This is useful if you need to
monitor local resources/attributes like disk usage, CPU load, memory usage, etc. on a remote host. 


`Nsclient++` : NSClient++ (or nscp as I tend to call it nowadays) aims to be a simple yet powerful and secure monitoring daemon for
Windows operating systems. on Nsclient++ we can run nrpe handler too.


#How windows process work ?

Each process provides the resources needed to execute a program. A process has a virtual address space, executable code, open handles to
system objects, a security context, a unique process identifier, environment variables, a priority class, minimum and maximum working set
sizes, and at least one thread of execution. Each process is started with a single thread, often called the primary thread, but can
create additional threads from any of its threads.

A thread is the entity within a process that can be scheduled for execution. All threads of a process share its virtual address space and
system resources. In addition, each thread maintains exception handlers, a scheduling priority, thread local storage, a unique thread
identifier, and a set of structures the system will use to save the thread context until it is scheduled. The thread context includes the
thread's set of machine registers, the kernel stack, a thread environment block, and a user stack in the address space of the thread's
process. Threads can also have their own security context, which can be used for impersonating clients.


#How to kill windows process using own windows application ?

Processes can be ended by process ID or image name. Taskkill replaces the kill tool same as on Gnu/Linux environment.


#And last, How NRPE can kill windows process via Nagios on Gnu/Linux host monitoring ?

First, NRPE Plugin will check daemon of NRPE/Nsclient++ on windows machine. And then, if command argument handler allow to execute on
local script windows/taskkill command, it will be executed. on this case, local script windows using wmi script. And Second, make interface using php shell exec to run kill command via web base nagios that integrated it.


#Prepare.

1. Install Nagios on your host monitoring. 
2. Download and install NRPE plugin. [monitoringexchange.org](http://www.monitoringexchange.org/inventory/Utilities/AddOn-Projects/Communication/NRPE/NRPE)
3. Download and install Nsclient++ on your remote monitoring. [download here](http://sourceforge.net/projects/nscplus/files/nscplus/)
you can see my Nsclient++ conf on <a href="/files/nsc.conf" target="_new">here</a> to walk out of this experiment. or u just added `nrpe handler` below:
{% highlight ruby %}
[NRPE Handlers]
command[show_os]=cscript.exe //nologo //T:60 C:\wmi-1.3\verify_wmi_status.vbs -h "$ARG1$"
command[kill_procs]=C:\WINDOWS\system32\taskkill.exe /S 127.0.0.1 /IM "$ARG1$" /F
command[show_procs]=cscript.exe //nologo //T:60 C:\wmi-1.3\get_computer_info.vbs -h "$ARG1$" -i running_processes
{% endhighlight %}
4. Download and put this wmi agents plugin to C:\.
<a href="http://monitoringforge.org/plugins/esp_frs/file.php?fileid=1974&id=1658&group_id=482&relid=1398&browse_file=y" target="_new">download here</a>


#PoC

Let me see

{% highlight ruby %}
C:\Documents and Settings\alinux>tasklist

Image Name                   PID Session Name     Session#    Mem Usage
========================= ====== ================ ======== ============
System                         4 Console                 0         36 K
SMSS.EXE                     424 Console                 0         32 K
CSRSS.EXE                    572 Console                 0      2,164 K
WINLOGON.EXE                 596 Console                 0      1,796 K
SERVICES.EXE                 748 Console                 0      1,336 K
LSASS.EXE                    760 Console                 0      1,736 K
VBoxService.exe              916 Console                 0        808 K
SVCHOST.EXE                  928 Console                 0      1,616 K
SVCHOST.EXE                 1012 Console                 0      1,364 K
SVCHOST.EXE                 1132 Console                 0      8,008 K
SVCHOST.EXE                 1228 Console                 0        920 K
SVCHOST.EXE                 1380 Console                 0        588 K
SPOOLSV.EXE                 1512 Console                 0      4,972 K
ALG.EXE                      432 Console                 0        228 K
EXPLORER.EXE                1852 Console                 0     16,072 K
VBoxTray.exe                1928 Console                 0        332 K
GrooveMonitor.exe           1936 Console                 0      1,760 K
CTFMON.EXE                  1948 Console                 0        652 K
cmd.exe                     1056 Console                 0        796 K
openvpn-gui-1.0.3.exe       1124 Console                 0        240 K
firefox.exe                 1784 Console                 0     17,652 K
SVCHOST.EXE                 1080 Console                 0      1,948 K
tasklist.exe                1616 Console                 0      4,340 K
wmiprvse.exe                 688 Console                 0      5,528 K
{% endhighlight %}

{% highlight ruby %}
C:\Documents and Settings\alinux>taskkill /IM firefox.exe
SUCCESS: The process "firefox.exe" with PID 1784 has been terminated.

C:\Documents and Settings\alinux>
{% endhighlight %}


Now, assumsed your Nagios and Nsclient++ works properly.

###Nagios

{% highlight bash %}
alinux@denbaguse:/usr/src/nrpe-2.0/src$ sudo /etc/init.d/nagios status
checking /usr/sbin/nagios...done (running).
alinux@denbaguse:/usr/src/nrpe-2.0/src$
{% endhighlight %}

###Nsclient++

{% highlight bash %}
C:\Program Files\NSClient++>netstat -a

Active Connections

  Proto  Local Address          Foreign Address        State
  TCP    de-89f18a389752:epmap  de-89f18a389752:0      LISTENING
  TCP    de-89f18a389752:microsoft-ds  de-89f18a389752:0      LISTENING
  TCP    de-89f18a389752:3389   de-89f18a389752:0      LISTENING
  TCP    de-89f18a389752:5666   de-89f18a389752:0      LISTENING
  TCP    de-89f18a389752:12489  de-89f18a389752:0      LISTENING
  TCP    de-89f18a389752:1026   de-89f18a389752:0      LISTENING
  TCP    de-89f18a389752:netbios-ssn  de-89f18a389752:0      LISTENING
{% endhighlight %} 
Nsclient using port 12489 and NRPE using port 5666.


##Check NRPE handler command on windows machine

{% highlight bash %}
C:\Program Files\NSClient++>cscript.exe //nologo //T:60 C:\wmi-1.3\verify_wmi_status.vbs -h 192.168.0.3
OK - Microsoft Windows XP Professional, SP 2.0

C:\Program Files\NSClient++>
{% endhighlight %}


##Check NRPE handler command on host monitoring

{% highlight bash %}
alinux@denbaguse:/usr/src/nrpe-2.0/src$ ./check_nrpe -H 192.168.0.3 -c show_os -a 192.168.0.3
OK - Microsoft Windows XP Professional, SP 2.0
alinux@denbaguse:/usr/src/nrpe-2.0/src$
{% endhighlight %}


Ok, sounds like good. Now, test kill process of nrpe handler command:

##on host monitoring

on example, i was killing notepad.exe process.

{% highlight bash %}
alinux@denbaguse:/usr/src/nrpe-2.0/src$ ./check_nrpe -H 192.168.0.3 -c kill_procs -a notepad.exe
SUCCESS: The process "NOTEPAD.EXE" with PID 1464 has been terminated.
SUCCESS: The process "NOTEPAD.EXE" with PID 708 has been terminated.
SUCCESS: The process "NOTEPAD.EXE" with PID 1972 has been terminated.
alinux@denbaguse:/usr/src/nrpe-2.0/src$
{% endhighlight %}

all process by name notepad.exe would be killed. you can terminate/kill process by pid.


#Integrating with nagios.

by doing check command line use `check_nrpe` :

{% highlight bash %}
alinux@denbaguse:/usr/src/nrpe-2.0/src$ ./check_nrpe -H 192.168.0.3 -c show_procs -a 192.168.0.3
Host name: 192.168.0.3; Running Processes: System Idle Process, System, SMSS.EXE, CSRSS.EXE, WINLOGON.EXE, SERVICES.EXE, LSASS.EXE,
VBoxService.exe, SVCHOST.EXE, SVCHOST.EXE, SVCHOST.EXE, SVCHOST.EXE, SVCHOST.EXE, SPOOLSV.EXE, ALG.EXE, EXPLORER.EXE, VBoxTray.exe,
GrooveMonitor.exe, CTFMON.EXE, cmd.exe, openvpn-gui-1.0.3.exe, SVCHOST.EXE, NOTEPAD.EXE, nsclient++.exe, cscript.exe, wmiprvse.exe,
alinux@denbaguse:/usr/src/nrpe-2.0/src$

{% endhighlight %}

k, lets begin to php code


{% highlight php %}
<?php

//catch
$host = $_GET["ip"];
$IM = $_GET["im"];
$config = $_GET["conf"];

//filter process name
if($IM == ""){
$killer = "";
}
else if($IM !== "" && $host == "172.16.0.35") {
echo "<script>alert('sorry u cant kill anything process on this host :P')</script>";
}
else {
$killer = '/usr/src/nrpe-2.0/src/check_nrpe -H '.$host.' -c kill_procs -a '.
$IM;
}

//executor kill process
$output = shell_exec($killer);


//filter host
if($host == ""){
$show_proses = "";
} else {
$show_proses = '/usr/src/nrpe-2.0/src/check_nrpe -H '.$host.' -c show_procs -a 127.0.0.1';
}

//executor show process
$show_procs = shell_exec($show_proses);


//filter config

if($config == "1"){
$run_config = '/usr/src/nrpe-2.0/src/check_nrpe -H '.$host.' -c update_config';
}
else if ($config == ""){
$run_config = "";
}
else {

echo "<script>alert('config value isnt valid')</script>";

}

//executor update config
$update_config = shell_exec($run_config);
?>
<!--
simply process killer using nrpe
pure coding php :lol:
-->

<?php
echo "<b>Process on $host</b>:<br> ";
echo "<pre>$output</pre><br/>";
//echo "$show_procs<br/>";

$explode = explode(", ",$show_procs);
for($i=0; $i<(count($explode));$i++){
echo "<a href=\"index.php?ip=".$host."&im=".$explode[$i]."\">".$explode[$i]."</a> ";
}

echo "<pre>$update_config</pre>";
?>


<form method="get" action="index.php">
Host:
<br><input type="text" name="ip" value="<?php echo "$host";?>"></input>
<br/>Update Config NSC<br/>
<select name="conf">
<option value="">No</option>
<option value="1">Yes</option>
</select>

<!-- <input type="text" name="conf2" value=""></input>
-->
<br/><input type="submit" value="Show">
</form>
<br/>
<a href="index.php">refresh page</a><br/>

{% endhighlight %}

save as `index.php` and put on your own directory (on example: `/usr/local/www/killer/index.php` )



##Last thing

just add new link on your side frame nagios webase this html code:

{% highlight html %}
<tr>                                                    
    <td width=13><img src="images/greendot.gif" width="13" height="14" name="tac-dot"></td>
    <td nowrap width=134><a href="/apache2-default/index.php" target="main" onMouseOver="switchdot('tac-dot',1)"
onMouseOut="switchdot('tac-dot',0)" class="NavBarItem">Process Killer</a></td>                                                           
</tr> 
{% endhighlight %}

##Results: look at <a href="http://img69.imageshack.us/img69/986/ssnagios.png" target="_new">here</a>


##Reference:

<a href="http://nagios.org" target="_new">nagios.org</a>
<br/>
<a href="http://www.monitoringexchange.org/inventory/Utilities/AddOn-Projects/Communication/NRPE/NRPE" target="_new">monitor exchange dot org</a>
<br/>
<a href="http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/taskkill.mspx?mfr=true" target="_new">microsoft.com</a>
<br/>
<a href="http://technet.microsoft.com/en-us/library/cc725602(WS.10).aspx" target="_new">technet.microsoft.com</a>
<br/>
<a href="http://msdn.microsoft.com/en-us/library/ms681917(v=VS.85).aspx" target="_new">msdn.microsoft.com</a>
<br/>
<a href="http://sourceforge.net/projects/nscplus/files/nscplus/" target="_new">sf.net</a>
<br/>
<a href="http://monitoringforge.org/plugins/esp_frs/file.php?fileid=1974&id=1658&group_id=482&relid=1398&browse_file=y" target="_new">monitoringforge.org</a>

###Thanks to:
1. Alit for reference idea.
2. Marion for explode function
3. last thanks to netzerospace for took my code again.

*this document specially for development of network monitoring of <a href="http://streetdirectory.co.id"
target="_new">streetdirectory</a> id office* and *i've tried on debian and freebsd machine for this experiment and successfully* :)
<br/>
*happy sysadmin day and happy jobless*

*created: djayakarta, finished: djogjakarta 30 July 2010*
