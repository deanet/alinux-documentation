--- 
layout: post_new
title: Replicate Master to Master MySQL
date: 2011-08-16 15:22:50
categories: 
- Replicate
- MySQL
- Master
---



##Preparation

1. Master 1, srv14: 111.68.112.43
2. Master 2, srv15: 111.68.112.44

Install mysql server on both server. look at <a href="/2011/08/14/compiling-mysql-5.5.12-with-cmake-on-centos.html">previous post</a> for this section.

##Configuration

###Master 1
<script src="https://gist.github.com/1144636.js?file=mm-1.my.cnf" type="text/javascript">
</script>

###Master 2
<script src="https://gist.github.com/1144636.js?file=mm-2.my.cnf" type="text/javascript">
</script>


##Setup Replication

###Setup Master 1

{% highlight bash %}
root@srv14 init.d# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 36
Server version: 5.5.12-log Source distribution

Copyright (c) 2000, 2010, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create user 'mysqlchkuser'@'localhost' identified by 'mysql321';

mysql> create user 'mmm_monitor'@'%' identified by 'monitor_password';
Query OK, 0 rows affected (0.06 sec)

mysql> create user 'agent_monitor'@'%' identified by 'agent_password';
Query OK, 0 rows affected (0.00 sec)


mysql> create user 'replication'@'%' identified by 'replication_password';
Query OK, 0 rows affected (0.00 sec)

mysql> GRANT REPLICATION CLIENT ON *.* TO 'mmm_monitor'@'%' IDENTIFIED BY 'monitor_password';
Query OK, 0 rows affected (0.00 sec)

mysql> GRANT SUPER, REPLICATION CLIENT, PROCESS ON *.* TO 'mmm_agent'@'%' IDENTIFIED BY 'agent_password';
Query OK, 0 rows affected (0.00 sec)

mysql> GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%' IDENTIFIED BY 'replication_password';
Query OK, 0 rows affected (0.00 sec)

mysql> 


mysql> flush privileges;
Query OK, 0 rows affected (0.01 sec)

mysql> flush tables with read lock;
Query OK, 0 rows affected (0.00 sec)




mysql> show master status;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000001 |     1044 |              |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)
{% endhighlight %}


####Dont Close this session

dump database to master 2.

{% highlight bash %}
# mysqldump -u root -p --all-databases > /tmp/database-backup.sql
# scp /tmp/database-backup.sql 111.68.112.44:~/
{% endhighlight %}




####Now, we can remove lock tables

{% highlight bash %}
mysql> unlock tables;
Query OK, 0 rows affected (0.00 sec)

{% endhighlight %}


####Go to Master 2

##Setup Master 2

{% highlight bash %}
root@srv15 mysql# mysql -u root -p < /root/database-backup.sql 
Enter password: 

root@srv15 mysql# 
root@srv15 mysql# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 90
Server version: 5.5.12-log Source distribution

Copyright (c) 2000, 2010, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> flush privileges;
Query OK, 0 rows affected (0.46 sec)

mysql> CHANGE MASTER TO master_host='111.68.112.43', master_port=3306, master_user='replication', 
    ->               master_password='replication_password', master_log_file='mysql-bin.000001', master_log_pos=1044;

Query OK, 0 rows affected (4.62 sec)

mysql> 
mysql> start slave;
Query OK, 0 rows affected (0.00 sec)

mysql> show slave status \G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 111.68.112.43
                  Master_User: replication
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000001
          Read_Master_Log_Pos: 1044
               Relay_Log_File: mysql-relay-bin.000002
                Relay_Log_Pos: 253
        Relay_Master_Log_File: mysql-bin.000001
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 1044
              Relay_Log_Space: 409
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 1
1 row in set (0.00 sec)

mysql> show master status
    -> ;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000002 | 27957968 |              |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)

mysql> show master status;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000002 | 27957968 |              |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)

root@srv15 mysql# 

{% endhighlight %}



##Switch Back to Master 1


{% highlight bash %}
mysql> CHANGE MASTER TO master_host='111.68.112.44', master_port=3306, master_user='replication', 
    ->               master_password='replication_password', master_log_file='mysql-bin.000002', master_log_pos=27957968;
Query OK, 0 rows affected (0.34 sec)

mysql> start slave;
Query OK, 0 rows affected (0.00 sec)

mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 111.68.112.44
                  Master_User: replication
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000002
          Read_Master_Log_Pos: 27957968
               Relay_Log_File: mysql-relay-bin.000002
                Relay_Log_Pos: 253
        Relay_Master_Log_File: mysql-bin.000002
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 27957968
              Relay_Log_Space: 409
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 2
1 row in set (0.00 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| c4CkV893_B4r7Hue   |
| mysql              |
| performance_schema |
+--------------------+
4 rows in set (0.00 sec)

mysql> create database mmreplicate;
Query OK, 1 row affected (0.03 sec)

mysql> \q
Bye
root@srv14 init.d#

{% endhighlight %}


##Check on Master 2

{% highlight bash %}
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| c4CkV893_B4r7Hue   |
| mmreplicate        |
| mysql              |
| performance_schema |
+--------------------+
5 rows in set (0.00 sec)

mysql> \q
Bye
root@srv15 mysql# 
{% endhighlight %}


[http://mysql-mmm.org/mmm2:guide](http://mysql-mmm.org/mmm2:guide)



