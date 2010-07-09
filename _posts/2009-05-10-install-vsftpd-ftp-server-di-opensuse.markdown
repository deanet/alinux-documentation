--- 
layout: post
title: Install vsftpd FTP Server di openSUSE
date: 2009-05-10 10:05:09
---
##Apa itu FTP ?
FFTP merupakan salah satu protokol Internet yang paling awal dikembangkan, dan masih digunakan hingga saat ini untuk melakukan pengunduhan (download) dan penggugahan (upload) berkas-berkas komputer antara klien FTP dan server FTP. Sebuah Klien FTP merupakan aplikasi yang dapat mengeluarkan perintah-perintah FTP ke sebuah server FTP, sementara server FTP adalah sebuah Windows Service atau daemon yang berjalan di atas sebuah komputer yang merespons perintah-perintah dari sebuah klien FTP. Perintah-perintah FTP dapat digunakan untuk mengubah direktori, mengubah modus transfer antara biner dan ASCII, menggugah berkas komputer ke server FTP, serta mengunduh berkas dari server FTP.


###Installasi vsftpd

	yast -i vsftpd

untuk menjalankan service vsftpd ketik:

	/etc/init.d/vsftpd start

agar user didalam mesin bisa login edit file `/etc/vsftpd.conf` . ubah sperti berikut:

	local_enable=YES

lalu agar kita bisa menulis/write ke dalam mesin ubah bagian berikut:

	write_enable=YES

lalu bisa di coba dengan [FileZilla](http://filezilla-project.org). gud lak ;)

Referensi:

1. [wikipedia.org](http://id.wikipedia.org/wiki/File_Transfer_Protocol)
2. [en.opensuse.org](http://en.opensuse.org/FTP_Server_HOWTO)
