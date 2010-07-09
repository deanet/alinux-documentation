--- 
layout: post
title: Install samba 3.x on FreeBSD 7.2
date: 2009-12-07 07:12:06
---
Install samba 3.x on FreeBSD 7.2. Silahkan juga di cobain d FreeBSD 8 :P ..

##1. Install
	
	# cd /usr/ports/net/samba3
	# make install clean

##2. konfigurasi
	
	# cp /usr/local/etc/smb.conf.default /usr/local/etc/smb.conf


##Issue:

1. Setiap user login dengan username dan password.
2. Setiap user dapat sharing file dengan user lainnya.
3. Ada sebuah folder yg hanya bisa ditulis/write oleh user tertentu (misal `user1`)


##configure:

a. Isi konfigurasi smb.conf seperti dibawah ini:
	
`vi /usr/local/etc/smb.conf`

{% highlight bash %}
#=======  Global Settings  ===========
[global]

   unix extensions = no
   workgroup = MSHOME
   server string = samba

   ## issue no 1
   security = user
   log file = /var/log/samba/log-%m.log
   max log size = 50
   dns proxy = no


#====== Share Definitions  =========

[homes]
   comment = Home Directories for %u on %h
   browseable = no
   writable = yes
   path = /usr/home/%u/Docs
   valid users = %S

## issue no 2
[public]
   comment = %h shared Public Stuff
   path = /usr/home/samba/public
   force directory mode = 1777
   force create mode = 1777
   force group = nobody
   force user = nobody
   public = yes
   writable = yes
   read only = no

## issue nomor 3
[software]
   comment = %h shared Software
   path = /usr/home/samba/software
   read only = yes
   write list = user1
   create mask = 0664
   directory mask = 0775
{% endhighlight %}


b. lalu bikin user misalnya `user1` dan `user2` , dan user `samba`

	adduser -v


c. Bikin folder Docs didalam directory `/home/user1` dan `/home/user2`

d. jgn lupa chown dan group nya. n pastikan perm

*owner*:
	
	chown user1 public
	chown user2 public

*group*:

	chgroup wheel public
	chgroup wheel public

e. bkin dir `public` (issue no 1)  dan software (issue no 3) di home samba untuk sharing antar user

	mkdir /home/samba/public

f. beri perm 777 untuk `public` dan 755 untuk `software`

	chmod 777 /home/samba/public
	chmod 755 /home/samba/software

g. klo uda set password user untuk samba nya:
	
	smbpasswd -a user1
	smbpasswd -a user2

##3. lalu jalankan smba nya

	/usr/local/etc/rc.d/samba start

##4. Testing

n cek \\ip.kamu :)


 semoga bermanfaat :)


Referensi:
1. [http://www.us-webmasters.com/FreeBSD/Install/Samba/](http://www.us-webmasters.com/FreeBSD/Install/Samba/)
