--- 
layout: post
title: Mengatasi no public key available di apt debian
date: 2010-06-23 10:52:53
---

Sekedar catatan pribadi saja sih, sering mendapatkan warning `no public key available` ketika menjalankan `apt-get` di `debian`.

{% highlight bash %}
W: There is no public key available for the following key IDs:
9AA38DCD55BE302B
W: You may want to run apt-get update to correct these problems
{% endhighlight %}


solusinya:

Dengan menjalankan `gpg --keyserver wwwkeys.eu.pgp.net --recv-keys 9AA38DCD55BE302B`. Dimana key `9AA38DCD55BE302B` adalah key yg `untrusted`.
{% highlight bash %}
denbaguse:/home/alinux# gpg --keyserver wwwkeys.eu.pgp.net --recv-keys 9AA38DCD55BE302B
gpg: directory `/root/.gnupg' created
gpg: can't open `/gnupg/options.skel': No such file or directory
gpg: keyring `/root/.gnupg/secring.gpg' created
gpg: keyring `/root/.gnupg/pubring.gpg' created
gpg: requesting key 55BE302B from hkp server wwwkeys.eu.pgp.net
gpg: /root/.gnupg/trustdb.gpg: trustdb created
gpg: key 55BE302B: public key "Debian Archive Automatic Signing Key (5.0/lenny) <ftpmaster@debian.org>" imported
gpg: no ultimately trusted keys found
gpg: Total number processed: 1
gpg:               imported: 1  (RSA: 1)
{% endhighlight %}


Lalu menambahkan key yang baru saja dibuat dengan `apt-key add` pada list key.
{% highlight bash %}
denbaguse:/home/alinux# apt-key add /root/.gnupg/pubring.gpg
OK
denbaguse:/home/alinux#
{% endhighlight %}

lalu jalankan kembali `apt-get`, insya Allah warning tidak akan muncul lagi. Dan untuk melihat list key `trusted` bisa dengan perintah:

`# apt-key list`

Referensi:
<a href="http://wiki.debian.org/SecureApt" target="_new">http://wiki.debian.org/SecureApt</a>

semoga membantu :)
