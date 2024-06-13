### SUID

If SUID bit is set on a file and a user executed it, the process will have the same rights as the owner of the file being executed.

SetUID - это бит разрешения, который позволяет пользователю запускать исполняемый файл с правами владельца этого файла. Другими словами, использование этого бита позволяет нам поднять привилегии пользователя в случае, если это необходимо.

Например никто не имеет прав изменять файл `/etc/shadow` кроме пользователя `root`:

```bash
ls -l /etc/shadow
-rw-r----- 1 root shadow 1250 фев 29 14:01 /etc/shadow
```

Но любой пользователь в системе может выполнить команду для смены пароля `passwd` и, из-за наличия бита `suid` на исполняемом файле `/usr/bin/passwd`, он получит права пользователя `root` и сможет обновить файл `/etc/shadow`.

```bash
ls -l /usr/bin/passwd
-rwsr-xr-x 1 root root 59976 фев  6 16:54 /usr/bin/passwd
```

Для примера создадим тестовый файл: `touch suidfile`.

```bash
ls -l suidfile
-rw-rw-r-- 1 aidar aidar 0 июн 12 18:12 suidfile
```

Повесим на него SUID: `chmod 4664 suidfile`.

Проверим результат:

```bash
ls -l suidfile
-rwSrw-r-- 1 aidar aidar 0 июн 12 18:12 suidfile
```

Если мы видим заглавную букву `S`, это означает права на запуск файла от имени владельца с правами только на чтение и запись.

Если же мы изменим права на файл следующим образом: `chmod 4764 suidfile`, то результат будет таким:

```bash
ls -l suidfile
-rwsrw-r-- 1 aidar aidar 0 июн 12 18:12 suidfile
```

Соответственно если мы видим маленькую букву `s`, это означает права на запуск файла от имени владельца с права на чтение, запись и исполнение.

### SGID

SGID - same as SUID, the process will have the same group rights of the file being executed. If SGID bit is set on any directory, all subdirectories and files created inside will get same group ownership as the main directory, it doesn’t matter who is creating.

Принцип работы SetGID очень похож на SetUID с отличием, что файл будет запускаться пользователем от имени группы, которая владеет файлом.

Для примера создадим тестовый файл: `touch sgidfile`.

```bash
ls -l sgidfile
-rw-rw-r-- 1 aidar aidar 0 июн 12 18:29 sgidfile
```

Повесим на него SGID: `chmod 2664 sgidfile`.

```bash
ls -l sgidfile
-rw-rwSr-- 1 aidar aidar 0 июн 12 18:29 sgidfile
```

Если мы видим заглавную букву `S`, это означает права на запуск файла от имени группы-владельца с правами только на чтение и запись.

Если же мы изменим права на файл следующим образом: `chmod 2674 suidfile`, то результат будет таким:

```bash
ls -l sgidfile
-rw-rwsr-- 1 aidar aidar 0 июн 12 18:29 sgidfile
```

Соответственно если мы видим маленькую букву `s`, это означает права на запуск файла от имени группы-владельца с правами на чтение, запись и исполнение.


Можно установить одновременно и SUID и SGID на один файл с помощью первой шестерки, например `6664`.

Для примера создадим тестовый файл: `touch both`.

Повесим на него SUID и SGID: `chmod 6664 both`.

```bash
ls -l both
-rwSrwSr-- 1 aidar aidar 0 июн 12 18:44 both
```

### Sticky Bit

If a directory with sticky bit enabled will restrict deletion of the file inside it. It can be removed by root, owner of the file or who have to write permission on it. This is useful for publically accessible directories like `/tmp`.

Создадим тестовую директорию: `mkdir stickydir`.

```bash
ls -ld stickydir/
drwxrwxr-x 2 aidar aidar 4096 июн 13 09:13 stickydir/
```

Повесим на нее sticky bit: `chmod +t stickydir` либо `chmod 1777 stickydir`.

```bash
ls -ld stickydir/
drwxrwxrwt 2 aidar aidar 4096 июн 13 09:13 stickydir/
```

Маленькая буква `t` означает права на чтение, запись, исполнение и установленный sticky bit.

Изменим права: `chmod 1666 stickydir`.

```bash
ls -ld stickydir/
drw-rw-rwT 2 aidar aidar 4096 июн 13 09:13 stickydir/
```

Большая буква `T` означает права только на чтение и запись, а также установленный sticky bit.

Искать в текущей директории файлы с установленным SUID: `find -perm /4000`.

Искать в текущей директории файлы с установленным SGID: `find -perm /2000`.

Искать в текущей директории файлы с установленным SUID либо SGID, либо SUID и SGID одновременно: `find -perm /6000`.

Установить SUID, SGID и sticky bit: `chmod u+s,g+s,o+t /home/bob/datadir`.
