Смотреть размер файлов: `ls -lah`. Здесь `h = human-readable`.

cd -   #вернет нас в предыдущую директорию
cp -r Receipts/ BackupReceipts/  #при копировании директорий необходимо указывать опцию r=recursive
cp -p   #p=preserve, сохранить все атрибуты файла-источника

Скопировать скрытые файлы по маске: `sudo cp -p /etc/skel/{.b*,.p*} default_data/`.

```bash
aidar@xubuntu-vm:~$ ls -la /etc/skel
total 24
drwxr-xr-x 2 root root 4096 Jan 11 14:03 .
drwxr-xr-x 1 root root 4096 Jul  2 05:22 ..
-rw-r--r-- 1 root root  220 Jan  6  2022 .bash_logout
-rw-r--r-- 1 root root 3771 Jan  6  2022 .bashrc
-rw-r--r-- 1 root root  807 Jan  6  2022 .profile
```