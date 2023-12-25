## Задание № 5. Практические навыки работы с ZFS ##
Отработать навыки работы с созданием томов export/import и установкой параметров.
1. Определение алгоритма с наилучшим сжатием.
2. Определить настройки пула.
3. Работа со снапшотом. Найти сообщение от преподавателей.

Цель:\
Научиться самостоятельно устанавливать ZFS, настраивать пулы, изучить основные возможности ZFS.
### 1. Определение алгоритма с наилучшим сжатием ###
Создаём 4 пула по два диска в режиме RAID 1 (зеркало):\
[root@otus-task5 ~]# **zpool create m1 mirror /dev/sdb /dev/sdc**\
[root@otus-task5 ~]# **zpool create m2 mirror /dev/sdd /dev/sde**\
[root@otus-task5 ~]# **zpool create m3 mirror /dev/sdf /dev/sdg**\
[root@otus-task5 ~]# **zpool create m4 mirror /dev/sdh /dev/sdi**

Информация о пулах:\
[root@otus-task5 ~]# **zpool list**\
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT\
m1     480M  21.9M   458M        -         -     2%     4%  1.00x    ONLINE  -\
m2     480M  17.9M   462M        -         -     2%     3%  1.00x    ONLINE  -\
m3     480M  11.1M   469M        -         -     1%     2%  1.00x    ONLINE  -\
m4     480M  39.6M   440M        -         -     5%     8%  1.00x    ONLINE  -

Добавим разные алгоритмы сжатия в каждую файловую систему:\
[root@otus-task5 ~]# **zfs set compression=lzjb m1**\
[root@otus-task5 ~]# **zfs set compression=lz4 m2**\
[root@otus-task5 ~]# **zfs set compression=gzip-9 m3**\
[root@otus-task5 ~]# **zfs set compression=zle m4**

Все файловые системы имеют разные методы сжатия:\
[root@otus-task5 ~]# **zfs get all | grep compression**\
m1    compression           lzjb                   local\
m2    compression           lz4                    local\
m3    compression           gzip-9                 local\
m4    compression           zle                    local

Убедимся, что файл был скачан во все пулы:\
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

Сколько места занимает один и тот же файл в разных пулах:\
[root@otus-task5 ~]# **zfs list**\
NAME   USED  AVAIL     REFER  MOUNTPOINT\
m1    21.8M   330M     21.6M  /m1\
m2    17.8M   334M     17.6M  /m2\
**m3    11.0M   341M     10.7M  /m3**\
m4    39.5M   312M     39.2M  /m4

Степень сжатия файлов:\
[root@otus-task5 ~]# **zfs get all | grep compressratio | grep -v ref**\
m1    compressratio         1.81x                  -\
m2    compressratio         2.22x                  -\
**m3    compressratio         3.63x                  -**\
m4    compressratio         1.00x                  -\
Видно, что алгоритм сжатия gzip-9 - самый эффективный.
### 2. Определить настройки пула ###
Проверим, возможно ли импортировать данный каталог в пул:
```
[root@otus-task5 ~]# zpool import -d zpoolexport/
   pool: otus
     id: 6554193320433390805
  state: ONLINE
 action: The pool can be imported using its name or numeric identifier.
 config:

        otus                         ONLINE
          mirror-0                   ONLINE
            /root/zpoolexport/filea  ONLINE
            /root/zpoolexport/fileb  ONLINE
```
Информация о составе импортированного пула:
```
[root@otus-task5 ~]# zpool status
...
  pool: otus
 state: ONLINE
  scan: none requested
config:

        NAME                         STATE     READ WRITE CKSUM
        otus                         ONLINE       0     0     0
          mirror-0                   ONLINE       0     0     0
            /root/zpoolexport/filea  ONLINE       0     0     0
            /root/zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors
```
Размер хранилища:\
[root@otus-task5 ~]# **zfs get available otus**\
NAME  PROPERTY   VALUE  SOURCE\
otus  available  350M   -\
Тип пула:\
[root@otus-task5 ~]# **zfs get readonly otus**\
NAME  PROPERTY  VALUE   SOURCE\
otus  readonly  off     default\
Значение recordsize:\
[root@otus-task5 ~]# **zfs get recordsize otus**\
NAME  PROPERTY    VALUE    SOURCE\
otus  recordsize  128K     local\
Какое сжатие используется:\
[root@otus-task5 ~]# **zfs get compression otus**\
NAME  PROPERTY     VALUE     SOURCE\
otus  compression  zle       local\
Какая контрольная сумма используется:\
[root@otus-task5 ~]# **zfs get checksum otus**\
NAME  PROPERTY  VALUE      SOURCE\
otus  checksum  sha256     local
### 3. Работа со снапшотом. Найти сообщение от преподавателей ###
Ищем в каталоге **/otus/test** файл с именем **secret_message**:\
[root@otus-task5 ~]# **find /otus/test -name "secret_message"**\
/otus/test/task1/file_mess/secret_message\
Содержимое этого файла:\
[root@otus-task5 ~]# **cat /otus/test/task1/file_mess/secret_message**\
https://otus.ru/lessons/linux-hl/
