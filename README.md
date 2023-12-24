## Задание № 5. Практические навыки работы с ZFS ##
Отработать навыки работы с созданием томов export/import и установкой параметров.
1. Определение алгоритма с наилучшим сжатием.
2. Определить настройки pool’a.
3. Найти сообщение от преподавателей.

Цель:\
Научится самостоятельно устанавливать ZFS, настраивать пулы, изучить основные возможности ZFS.
### 1. Определение алгоритма с наилучшим сжатием ###
[root@otus-task5 ~]# **zpool list**\
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT\
m1     480M  21.9M   458M        -         -     2%     4%  1.00x    ONLINE  -\
m2     480M  17.9M   462M        -         -     2%     3%  1.00x    ONLINE  -\
m3     480M  11.1M   469M        -         -     1%     2%  1.00x    ONLINE  -\
m4     480M  39.6M   440M        -         -     5%     8%  1.00x    ONLINE  -

[root@otus-task5 ~]# **zfs get all | grep compression**\
m1    compression           lzjb                   local\
m2    compression           lz4                    local\
m3    compression           gzip-9                 local\
m4    compression           zle                    local
[root@otus-task5 ~]# **ls -l /m***\
/m1:\
total 22065\
-rw-r--r--. 1 root root 40997929 Dec  2 09:17 pg2600.converter.log

/m2:\
total 17994\
-rw-r--r--. 1 root root 40997929 Dec  2 09:17 pg2600.converter.log

/m3:\
total 10961\
-rw-r--r--. 1 root root 40997929 Dec  2 09:17 pg2600.converter.log

/m4:\
total 40069\
-rw-r--r--. 1 root root 40997929 Dec  2 09:17 pg2600.converter.log

