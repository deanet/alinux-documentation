--- 
layout: post
title: How to view cacti graphics without Login
date: 2009-07-27 03:07:00
---

I was wasting time to find how to view cacti graphics without login. It's simply, but make me stuck ! :D . okay, to view cacti graphics without login, you must enable first guest user.

##1. Enable guest user.
Login as `admin` and click `User Management` >> `guest`<br/>
Password: `guest`<br/>
Determines if user is able to login : `checked`
<br/>User Must Change Password at Next Login: `Unchecked`

##2. Setting Graph permission.

Click Tab Graph Permissions >> `allow and Add Graph for host`

##3. Login as `guest` user and `logout`.
##4. Login as admin and `click Settings` >> `Authentication` >> `Guest User` : `guest`
##5. and now try access `http://domain/cacti/graph_view.php`


Reference:

1. [forums.cacti.net](http://forums.cacti.net/about30462.html)
