--- 
layout: post
title: How to Terminate, Suspend, and Continue a process using kill
date: 2010-03-28 04:00:03
---
Dalam <a title="Computing" href="http://en.wikipedia.org/wiki/Computing" target="_new">computing</a> (komputasi), `kill` adalah sebuah <a title="Command (computing)" href="http://en.wikipedia.org/wiki/Command_%28computing%29">perintah</a> yang digunakan dalam sistem operasi untuk mengirimkan sinyal ke sebuah <a title="Process (computing)" href="http://en.wikipedia.org/wiki/Process_%28computing%29">process</a> yang sedang berjalan. Contohnya kita bisa men-terminate program / process yang sedang berjalan.


Jika kita berbicara mengenai kill, tentu saja ini berhubungan dengan <a href="http://en.wikipedia.org/wiki/System_call" target="_new">system call</a> kill dan <a href="http://en.wikipedia.org/wiki/Signal_%28computing%29" target="_new">signal processing</a>. Untuk lebih lengkapnya silahkan baca sendiri di <a href="http://en.wikipedia.org">Wikipedia</a> sudah komplit2.. :P . Pada intinya system call / kill() berhubungan dengan signal. Dibawah ini model status proses di Unix.

Terkait judul diatas hanya Terminate, Suspend, dan Kill. Maka saya hanya menjelaskan tiga hal tersebut. Untuk temen-temennya terminate,suspend,dan kill lainya bisa dibaca sendiri di manual page ( man signal) atau di <a href="http://en.wikipedia.org/wiki/Signal_%28computing%29" target="_new">wikipedia</a> (pengertian secara umum).

Oiya, dalam percobaan saya ini menggunakan FreeBSD dan Slackware. Silahkan praktikan sendiri dimesin Unix like lainnya :P.

#<a href="http://en.wikipedia.org/wiki/SIGTERM" target="_new">Terminate</a>
Terminate dalam process signal ada beberapa macam.. setahu saya ada 2 macam. Silahkan baca lagi di <a href="http://en.wikipedia.org/wiki/Signal_%28computing%29">wikipedia</a>. Yang saya coba di sini adalah signal no #9 .. Oiya, signal ini memiliki urutan<a href="http://en.wikipedia.org/wiki/Signal.h">signal </a>. Jadi Signal #9 adalah signal yang men-terminate secara tidak normal dari sbuah proses dan harus dilaksanakan secepatnya. *doh maksude pie kui* :D

Ok, sekarang kita praktekan sendiri2..:

Perintahnya:

`kill -9 pid`

dimna `pid` adalah nomor `pid` = `process id`.

secara umum perintahnya adalah seperti diatas. Jika menggunakan TOP di FreeBSD pada saat top runninng, ketik `k` lalu isi `-9 pid`. Saya coba dengan menggunakan mesin slackware 13, agak sedikit berbeda. Ketik `k` lalu isi `pid`, baru `nomor signal`. Tapi nomor signal kill tetap sama yaitu no `9` . :D

#<a href="http://en.wikipedia.org/wiki/SIGTSTP" target="_new">Suspend.</a>
Perintah sinyal suspend akan dijalankan pada process yang berjalan dengan perintah:
FreeBSD:

`kill -17 pid`

Slackware:

`kill -19 pid`

Dalam `signal suspend` ini ada 2 macam jika di environment freebsd. `signal 17` sama `18`. Perbedaan nya jika `signal 17` tidak dapat diabaikan jika perintah dari inputan keyboard atau system sendiri (cron misal). Jika `signal 18` hanya dapat berjalan jika inputan command berasal dari keyboard / terminal. Begitu juga di Slackware, `signal 19` dengan `20` sama seperti `signal 17` dengan `18` di FreeBSD.


#<a href="http://en.wikipedia.org/wiki/SIGCONT" target="_new">Continue</a>

Perintah sinyal continue akan dijalankan pada process yang berjalan dengan perintah:

FreeBSD:

`kill -19 pid`

Slackware:

`kill -18 pid`


Setelah itu bisa anda praktekan sendiri-sendiri. Misal pada pemutar musik anda :mrgreen: serasa hang tapi bukan hang. atau pada ssh koneksi temen anda pada waktu login. Lho.. koq dipencet2 command na g kluar2, apa koneksi nya putus ???? koq g ada connection time out.... heee.. yaaa.. betul, proses anda sedang di pause / suspend :P.


##Berikut List Signal di `Slackware`:

{% highlight xml %}
bash-3.1$ kill -l
 1) SIGHUP       2) SIGINT       3) SIGQUIT      4) SIGILL
 5) SIGTRAP      6) SIGABRT      7) SIGBUS
8. SIGFPE
 9) SIGKILL     10) SIGUSR1     11) SIGSEGV     12) SIGUSR2
13) SIGPIPE     14) SIGALRM     15) SIGTERM     16) SIGSTKFLT
17) SIGCHLD     18) SIGCONT     19) SIGSTOP     20) SIGTSTP
21) SIGTTIN     22) SIGTTOU     23) SIGURG      24) SIGXCPU
25) SIGXFSZ     26) SIGVTALRM   27) SIGPROF     28) SIGWINCH
29) SIGIO       30) SIGPWR      31) SIGSYS      34) SIGRTMIN
35) SIGRTMIN+1  36) SIGRTMIN+2  37) SIGRTMIN+3  38) SIGRTMIN+4
39) SIGRTMIN+5  40) SIGRTMIN+6  41) SIGRTMIN+7  42) SIGRTMIN+8
43) SIGRTMIN+9  44) SIGRTMIN+10 45) SIGRTMIN+11 46) SIGRTMIN+12
47) SIGRTMIN+13 48) SIGRTMIN+14 49) SIGRTMIN+15 50) SIGRTMAX-14
51) SIGRTMAX-13 52) SIGRTMAX-12 53) SIGRTMAX-11 54) SIGRTMAX-10
55) SIGRTMAX-9  56) SIGRTMAX-8  57) SIGRTMAX-7  58) SIGRTMAX-6
59) SIGRTMAX-5  60) SIGRTMAX-4  61) SIGRTMAX-3  62) SIGRTMAX-2
63) SIGRTMAX-1  64) SIGRTMAX
{% endhighlight %}

##Dan berikut List signal di `FreeBSD`:

{% highlight xml %}
 No    Name 	Default Action	     Description
     1	   SIGHUP	terminate process    terminal line hangup
     2	   SIGINT	terminate process    interrupt program
     3	   SIGQUIT	create core image    quit program
     4	   SIGILL	create core image    illegal instruction
     5	   SIGTRAP	create core image    trace trap
     6	   SIGABRT	create core image    abort program (formerly SIGIOT)
     7	   SIGEMT	create core image    emulate instruction executed
     8	   SIGFPE	create core image    floating-point exception
     9	   SIGKILL	terminate process    kill program
     10    SIGBUS	create core image    bus error
     11    SIGSEGV	create core image    segmentation violation
     12    SIGSYS	create core image    non-existent system call invoked
     13    SIGPIPE	terminate process    write on a pipe with no reader
     14    SIGALRM	terminate process    real-time timer expired
     15    SIGTERM	terminate process    software termination signal
     16    SIGURG	discard signal	     urgent condition present on
					     socket
     17    SIGSTOP	stop process	     stop (cannot be caught or
					     ignored)
     18    SIGTSTP	stop process	     stop signal generated from
					     keyboard
     19    SIGCONT	discard signal	     continue after stop
     20    SIGCHLD	discard signal	     child status has changed
     21    SIGTTIN	stop process	     background read attempted from
					     control terminal
     22    SIGTTOU	stop process	     background write attempted to
					     control terminal
     23    SIGIO	discard signal	     I/O is possible on a descriptor
					     (see fcntl(2))
     24    SIGXCPU	terminate process    cpu time limit exceeded (see
					     setrlimit(2))
     25    SIGXFSZ	terminate process    file size limit exceeded (see
					     setrlimit(2))
     26    SIGVTALRM	terminate process    virtual time alarm (see
					     setitimer(2))
     27    SIGPROF	terminate process    profiling timer alarm (see
					     setitimer(2))
     28    SIGWINCH	discard signal	     Window size change
     29    SIGINFO	discard signal	     status request from keyboard
     30    SIGUSR1	terminate process    User defined signal 1
     31    SIGUSR2	terminate process    User defined signal 2
     32    SIGTHR	terminate process    thread interrupt
{% endhighlight %}

semoga bermanffaat :)

ref:
1. man signal
2. man kill
3. wikipedia
