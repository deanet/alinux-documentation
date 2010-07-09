--- 
layout: post
title: Perintah Linux beserta kegunaanya
date: 2007-02-19 19:00:00
---


`cd x` atau `cd /x` :  masuk ke direktori x<br/>
`cd ..` atau `cd ../` atau `cd/..` :  pindah ke direktori satu level di bawah<br/>
`x lalu [tab] [tab]` : berguna untuk mengetahui perintah apa saja yang tersedia yang berawalan huruf x. *hanya di bash shell atau csh*<br/>
`adduser` : untuk menambahkan user baru<br/>
`ls` atau `dir` : untuk melihat isi suatu direktori<br/>
`cat` : untuk melihat isi dari suatu file text<br/>
`mv x y` : untuk memindahkan atau merename file x ke file y<br/>
`cp x y` : untuk mengkopi file x ke file y<br/>
`rm x` : untuk menghapus file x<br/>
`mkdir x` : untuk membuat direktori x<br/>
`rmdir x` : untuk menghapus direktori x<br/>
`rm -r x` : untuk menghapus direktori x beserta seluruh isinya<br/>
`rm p` : untuk menghapus paket tertentu<br/>
`df` atau `df x` : untuk mengetahui space kosong dalam device x<br/>
`top` : untuk mengetahui status memori (tekan q untuk quit)<br/>
`man x` : untuk mengetahui keterangan manual dari suatu perintah<br/>
`less x` : untuk melihat isi dari suatu file text<br/>
`echo x` : untuk mencetak isi dari suatu file x ke screen<br/>
`mc` : untuk menghidupkan Norton Commander dalam Linux (sangat berguna dan memudahkan bagi newbie)<br/>
`mount` : untuk menghidupkan suatu device spt cdrom<br/>
`halt` : untuk shutdown<br/>
`reboot` atau `[ctl + alt + del]` : untuk reboot<br/>

`chmod` : untuk mengubah permission suatu file<br/>
`ls -l x` : untuk melihat isi suatu direktori secara rinci<br/>
`ln -s x y` : untuk membuat symbolik link dari suatu file x ke nama file y. x=target y=nama link<br/>
`find x -name y -print` : untuk menemukan file y, dengan mencari mulai dari direktori x dan tampilkan hasilnya pada layar<br/>
`ps` : untuk melihat seluruh proses yang sedang berjalan<br/>
`kill x` : untuk mematikan proses x (x adalah PID di dalam ps)<br/>
`[alt] + F1 - F7` : untuk berpindah dari terminal 1 - 7 (ciri khas Linux)<br/>
`lilo` : untuk membuat boot disk<br/>

`startx` : untuk menjalankan X-Windows<br/>
`[ctl] + [alt] + [backspace]` : untuk keluar dari X-Windows jika terjadi trouble<br/>
`[ctl] + [alt] + F1 - F6` : untuk pindah dari satu terminal ke terminal lain dalam X-Windows<br/>
`xf86Config` : untuk mengeset X (primitif) dalam text mode<br/>

`Xconfigurator` : sama seperti di atas<br/>

> *diambil dari sebuah artikel entah dari mana saya lupa :D*


**Tambahan dari saya**

`lsof` : melihat akses file system, digunakan untuk mengetahui file mana yang sedang digunakan.<br/>
`vmstat` : digunakan untuk melihat virtual memori statistik.<br/>
`lsmod` : digunakan untuk melihat modul2 kernel yang diload.<br/>
`lspci`: digunakan untuk melihat daftar device pci yang ada.<br/>
`lsusb` : digunakan untuk melihat daftar device usb yang ada.<br/>
`init [0-6]` : init 0 untuk shutdown, init 6 untuk reboot, init 1-5 tergantung dari inittab distro.<br/>
`ps` : digunakan untuk melihat proses yang sudah dijalankan. bisa dengan tambahan opsi `aux`. `ps aux` atau `ps --help` untuk lengkapnya.<br/>
`netstat` : digunakan untuk melihat port yang listen atau eta. umumnya sysadmin / netadmin menggunakan dengan perintah `netstat -ntlp`.<br/>
`grep` : digunakan untuk memotong hasil tangkapan perintah dengan bantuan pipe (`|`). misal `ls | grep daftar` .<br/>
`ldd` : digunakan untuk melihat dinamik link library dari file binary. contoh, `ldd /bin/sh`<br/>
`w` : digunakan untuk melihat siapa saja yang login dan sedang melakukan apa, dari terminal mana.<br/>
`who` : mirip perintah `w` tetapi lebih ringkas.<br/>
`traceroute` : digunakan untuk melihat routing dari pc kita ke sebuah server yang dituju.<br/>
`&` : perintah `&` , eh bukan perintah sih. lebih ke parameter, atau apa ? . kegunaannya untuk melaksanakan sebuah proses menjadi background/tanpa ditampilkan dilayar. contoh, `find / > test.txt & `<br/>
`nohup` : digunakan untuk melakukan proses tanpa hang up. artinya jika sebuah session terminal diclose, maka proses akan tetap berjalan. misal, `nohup find / > test.txt &`.<br/>
`whereis`, `which`, `locate` : digunakan untuk mencari lokasi file.<br/>
`last` : digunakan untuk melihat login terakhir dari user yang sudah login.<br/>
`lastlog` : digunakan untuk melihat semua user, kapan terakhir login.<br/>
`adduser` : untuk menambahkan user baru dengan interaktif prompt. misal `adduser deanet` <br/>
`useradd` : digunakan untuk menambahkan user baru tanpa interaktif prompt. misal, `adduser -G nama_user -ms /bin/sh nama_user`.<br/>
`usermod` : digunakan untuk merubah group dari user. misal : `usermod -G group1,group2,group3 nama_user`.<br/>
`groupadd` : digunakan untuk menambahkan group. misal : `groupadd nama_group`<br/>
`groupdel` : digunakan untuk menghapus group. misal: `groupdel nama_group`<br/>



perintah2 diatas hanyalah sebagian kecil dari yang ada, masih banyak perintah lain (progi). untuk lebih lengkap informasi dari perintah diatas, bisa dilihat dengan manual pages dan opsi help. misal:

`cat --help`

`man cat`

> *seorang hacker sekalipun tidak dapat menghafal semua perintah2 linux maupun `*nix` like lainnya. ~S'to*<br/>
> *jadi jangan anda berbangga hati jika anda sudah hafal semua perintah yang ada, Allah Maha Besar. ~dhan*<br/>
> *last update: 21 May 2010*
