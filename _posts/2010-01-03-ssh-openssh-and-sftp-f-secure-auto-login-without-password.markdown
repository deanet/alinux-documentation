--- 
layout: post
title: SSH (OpenSSH) and SFTP (F-Secure) auto login without password
date: 2010-01-03 03:01:00
---

Tutor ini intiny gimna cara nya auto login dengan menggunakan `SSH` memakai `OpenSSH` dan `SFTP` memakai `F-Secure`.

##untuk SSH:

####Buat Public Key di Client Server

####Buat Public Key di Client lalu masukkan ke `authorized_keys` Main Server.

Setup di Client Monitoring server:

{% highlight bash %}
deanet@deanet:~/tmp$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/deanet/.ssh/id_rsa): f7
Enter passphrase (empty for no passphrase): "ENTER";
Enter same passphrase again: "ENTER";
Your identification has been saved in f7.
Your public key has been saved in f7.pub.
The key fingerprint is:
c1:7d:58:40:0b:77:6b:d8:03:b2:d6:11:89:dd:f1:a7 deanet@deanet
{% endhighlight %}

Lalu Kopi ke Main Server

{% highlight bash %}
deanet@deanet:~/tmp$ scp f7.pub 192.168.1.7:/home/deanet
Password:f7.pub                                        100%  395     0.4KB/s   00:00
{% endhighlight %}	

Setup di Main Server:

Login lalu jalankan:

{% highlight bash %}
cat f7.pub > .ssh/authorized_keys
{% endhighlight %}

test Apakah sudah jalan dengan baik:
{% highlight bash %}
deanet@deanet:~/tmp$ ssh -i f7 192.168.1.2 echo test
{% endhighlight %}

jika berhasil maka akan keluar kata test ...

##ok, untuk SFTP

Untuk `SFTP`, kenapa sayah mengikutsertakan `SFTP` ??? padahal `sftp` sendiri digunakan dilingkungan windo$m, sementara ini adalh blog linux wwkwkwkw.... Karena pada kenyataannya sedikit sekali dokumentasi di google tentang auto login dengan `SFTP` memakai `F-Secure` yg jalan di wedu$. Dan konfigurasi auto login dengan public key nya pun tidak semudah yang dibayangkan, karena dalam implementation nya ternyata ada sedikit perbedaan antara chipper rsa yg dibikin oleh open ssh client dengan produk dari `F-Secure`..

Okeee...

Jadi untuk `SFTP` sebenernya masalahnya gini:

1. Ada mesin `windo$` yg terinstall `F-Secure`, `SSH` dimatikan, dan yg hidup hanya `SFTP` saja.
2. Sudah bikin public key lalu dikonfigure ke mesin wedus tapi tetep aj failed authorization :(
Dan solusinya:

{% highlight bash %}
[deanet@some-host ~]$ ssh-keygen -b 1024 -t rsa -f mykey
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
<ENTER SAJA>
Enter same passphrase again:
<ENTER SAJA>
Your identification has been saved in mykey.
Your public key has been saved in mykey.pub.
The key fingerprint is:
4b:95:8c:ba:12:1c:19:0a:bb:d7:d2:29:3e:8b:ec:2f deanet@some-host.com
{% endhighlight %}

konvert ke `F-Secure` Implementation:

{% highlight bash %}
[deanet@some-host ~]$ ssh-keygen -e -f mykey.pub > mykey-secsh.pub
[deanet@some-host ~]$ ls
mykey  mykey.pub  mykey-secsh.pub
[deanet@some-host ~]$ mkdir .sh
[deanet@some-host ~]$ mv .sh .ssh
[deanet@some-host ~]$ mv mykey* .ssh
[deanet@some-host ~]$ ls
[deanet@some-host ~]$ cd .ssh
[deanet@some-host .ssh]$ ls
mykey  mykey.pub  mykey-secsh.pub
{% endhighlight %}

rename `mykesy` to `id_dsa`

{% highlight bash %}
[deanet@some-host .ssh]$ mv mykey id_dsa
{% endhighlight %}

lalu testing:

{% highlight bash %}
[deanet@some-host .ssh]$ sftp -o Port=9991 -v deanet@some-ip
Connecting to some-ip...
OpenSSH_4.3p2, OpenSSL 0.9.8e-fips-rhel5 01 Jul 2008
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: Applying options for *
debug1: Connecting to some-ip [some-ip] port 9991.
debug1: Connection established.
debug1: identity file /home/deanet/.ssh/id_rsa type -1
debug1: identity file /home/deanet/.ssh/id_dsa type -1
debug1: loaded 2 keys
debug1: Remote protocol version 2.0, remote software version 3.2.3 F-Secure SSH Windows NT Server
debug1: no match: 3.2.3 F-Secure SSH Windows NT Server
debug1: Enabling compatibility mode for protocol 2.0
debug1: Local version string SSH-2.0-OpenSSH_4.3
debug1: SSH2_MSG_KEXINIT sent
debug1: SSH2_MSG_KEXINIT received
debug1: kex: server->client aes128-cbc hmac-md5 none
debug1: kex: client->server aes128-cbc hmac-md5 none
debug1: sending SSH2_MSG_KEXDH_INIT
debug1: expecting SSH2_MSG_KEXDH_REPLY
The authenticity of host 'some-ip (some-ip)' can't be established.
DSA key fingerprint is 50:b9:e9:1c:a9:a7:11:ce:5d:ee:6e:e9:88:cc:99:57.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'some-ip' (DSA) to the list of known hosts.
debug1: ssh_dss_verify: signature correct
debug1: SSH2_MSG_NEWKEYS sent
debug1: expecting SSH2_MSG_NEWKEYS
debug1: SSH2_MSG_NEWKEYS received
debug1: SSH2_MSG_SERVICE_REQUEST sent
debug1: SSH2_MSG_SERVICE_ACCEPT received
debug1: Authentications that can continue: publickey
debug1: Next authentication method: publickey
debug1: Trying private key: /home/deanet/.ssh/id_rsa
debug1: Trying private key: /home/deanet/.ssh/id_dsa
debug1: read PEM private key done: type RSA
debug1: Authentication succeeded (publickey).
debug1: channel 0: new [client-session]
debug1: Entering interactive session.
debug1: Sending environment.
debug1: Sending env LANG = en_US.UTF-8
debug1: Sending subsystem: sftp
sftp> exit
debug1: client_input_channel_req: channel 0 rtype exit-status reply 0
debug1: channel 0: free: client-session, nchannels 1
debug1: fd 0 clearing O_NONBLOCK
debug1: Transferred: stdin 0, stdout 0, stderr 0 bytes in 4.3 seconds
debug1: Bytes per second: stdin 0.0, stdout 0.0, stderr 0.0
debug1: Exit status 0
{% endhighlight %}

ok, done... ;)
semoga bermanfaat

Reference:
1. <http://www.derkeiler.com/Mailing-Lists/securityfocus/Secure_Shell/2004-11/0062.html>
2. <http://ngadimin.com/2009/06/16/login-ssh-tanpa-password/>
3. <http://www.fixya.com/support/t21364-f_secure_ssh_server_authentications_over>
