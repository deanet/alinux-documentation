--- 
layout: post
title: Perlukah Belajar Linux ??
date: 2007-09-22 09:00:00
---

> *Perlukah Belajar Linux/Unix kalau Sudah  Ada Software Komersial di Industri?*

**Pengantar :**

Pertanyaan di atas pernah diajukan oleh salah seorang rekan saya. Pertanyaannya sederhana tapi menggelitik. "Perlu nggak sih kita belajar Linux/UNIX kalau akhirnya waktu kerja di industri kita menggunakan software komersial yang tinggal click here dan click there", kira-kira begitu pertanyaan rekan tersebut. Jawaban paling gampang adalah : "Ya terserah kamu saja" .


**Contoh Kasus :**

Yaaak, jawaban yang pas mungkin demikian. Terserah kepada Anda apakah mau belajar Linux/UNIX atau tidak. Sebagian orang punya keinginan untuk mengembangkan diri, sedang sebagian lagi "cari yang praktis saja". Bagi yang punya keinginan mengembangkan diri (baca : menambah pengetahuan) pasti pertanyaan di atas dijawab dengan "perlu".
Tulisan ini tidak bermaksud untuk "memaksa Anda" untuk belajar Linux, tapi untuk "mengenal" kelebihan Linux. Selanjutnya : terserah Anda (begitu bunyi salah satu iklan yang populer di Indonesia).

Baru-baru ini, seorang rekan saya yang sedang melakukan penelitian dengan sebuah software komersial yang dijalankan dengan sistem operasi UNIX menceritakan problem yang dialaminya kepada saya. Problemnya adalah sebagai berikut : Software komersial yang digunakannya menghasilkan sebuah file ASCII yang cukup panjang (puluhan ribu baris ...!!). Dari file ASCII tersebut dia harus mengambil data tertentu (nilai x dan y) dan menyimpannya ke sebuah file yang lain, untuk dibuatkan kurva berdasarkan harga-harga yang diambilnya. "Gimana ngedit-nya kalau begini?" , tanya teman saya. Itu baru satu file. Kalau satu hari sepuluh file ... ???

Ketika saya perhatikan, file output dari software tersebut memiliki pola yang berulang (karena memang biasanya demikian, untuk memudahkan kita .... !!!). Polanya kurang lebih seperti ini (misalnya) :
	
	x-value= 0.0000e+00
	y-value= 1.0000e+00
	.......................... (angka-angka)
	.......................... (angka-angka)
	:::
	::: (masih ada angka lagi)
	:::
	x-value= 1.0000e+00
	y-value= 2.5000e+00
	..........................
	..........................
	:::
	::: (dan seterusnya)
	:::

 Problem Solving :
==================

Saya-pun memberitahukan rekan saya tersebut beberapa rahasia Linux/UNIX. Rahasianya adalah sebagai berikut : Andaikan file ASCII tersebut bernama dataku. Maka untuk membuat file output yang berbentuk data x dan y, maka kita cukup gunakan kombinasi perintah Linux seperti cat, grep, awk, paste, "&gt;" (redirection), dan "|" (pipe).
Sebagai contoh, bila kita ketikkan

	cat dataku | grep 'x-value='

maka kita akan dapatkan keluaran di layar monitor sebagai berikut:

	x-value= 0.0000e+00
	x-value= 1.0000e+00
	:::
	::: (dan seterusnya)
	:::

Kalau kita gabungkan dengan awk :
	
	cat dataku | grep 'x-value=' | awk '{print $2}'

maka kita akan dapatkan:

	0.0000e+00
	1.0000e+00
	:::
	::: (dan seterusnya)
	:::

Untuk menyimpan ke file kita gunakan tanda "&gt;" dan nama file output. Jadi lengkapnya
	
	cat dataku | grep 'x-value=' | awk '{print $2}' &gt; datax

Untuk menyimpan data y, cukup ketikkan :

	cat dataku | grep 'y-value=' | awk '{print $2}' &gt; datay

Bagaimana menggabung kedua file tersebut? Cukup gunakan :
	
	paste -d' ' datax datay &gt; dataxy

Kalau kita display isi file dataxy dengan more dataxy atau cat dataxy maka akan kita dapatkan :
	0.0000e+00 1.0000e+00
	1.0000e+00 2.5000e+00
	:::
	::: (dan seterusnya)
	:::

Untuk membuat plot-nya, bisa digunakan gnuplot atau perangkat lunak lainnya.
Akhir Cerita
Rekan saya segera mencoba resep tersebut, dan tidak lama kemudian dia telah tersenyum lebar. Kesimpulannya ? IT'S UP TO YOU .
Dr. Leonard Lisapaly
Program Geofisika - Universitas Indonesia
Depok 16424

Diambil dari  www.elektroindonesia.com setelah ngabul-abul file di Os nya miekarosup. :D

> *tambahan editor: berita lama yg masih enak dibaca. Masih mau lanjut dg Linux ?*

keyword : linux, unix, awk, cat, perintah, command, belajar, more, grep
