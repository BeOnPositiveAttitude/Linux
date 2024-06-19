### Hard links

Посмотреть информацию о файле, в том числе номер inode, количество линков на этот файл, permissions и пр.: `stat file1`.

**inode** указывает на блоки данных на диске, в которых хранится файл, а также содержит метаданные о файле (дата создания, permissions и т.д.)

Создать hard link: `ln path_to_target_file path_to_link_file`.

Например: `ln /home/aaron/Pictures/family_dog.jpg /home/jane/Pictures/family_dog.jpg`.

Здесь картинка в домашнем каталоге пользователя `aaron` - это исходный файл, а картинка в домашнем каталоге пользователя `jane` - это hard link.

Hard link указывает на ту же самую inode, что и оригинальный файл.

Если пользователь `aaron` удалит картинку, то пользователь `jane` все равно сможет ее открыть через свой hard link, т.к. у inode останется "живая" link на этот файл.

Например, у нас есть файл `shell.txt`, содержащий внутри текст `test string`.

```bash
aidar@xubuntu-vm:~$ stat shell.txt

  File: shell.txt
  Size: 10              Blocks: 8          IO Block: 4096   regular file
Device: fc00h/64512d    Inode: 307248      Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/   aidar)   Gid: ( 1000/   aidar)
Access: 2024-06-19 09:24:09.823904311 +0400
Modify: 2024-06-17 09:33:24.824301336 +0400
Change: 2024-06-17 09:33:24.824301336 +0400
 Birth: 2024-06-17 09:33:24.824301336 +0400
```

Создадим hard link на этот файл: `ln shell.txt hl-shell.txt`.

Посмотрим как поменялось количество ссылок на исходный файл:

```bash
aidar@xubuntu-vm:~$ stat shell.txt

  File: shell.txt
  Size: 10              Blocks: 8          IO Block: 4096   regular file
Device: fc00h/64512d    Inode: 307248      Links: 2
Access: (0664/-rw-rw-r--)  Uid: ( 1000/   aidar)   Gid: ( 1000/   aidar)
Access: 2024-06-19 09:24:09.823904311 +0400
Modify: 2024-06-17 09:33:24.824301336 +0400
Change: 2024-06-19 09:24:50.322652959 +0400
 Birth: 2024-06-17 09:33:24.824301336 +0400
```

Теперь удалим исходный файл: `rm shell.txt`. И попробуем получить содержимое hard link:

```bash
aidar@xubuntu-vm:~$ cat hl-shell.txt
test string
```

Если же удалить и hard link, то тогда уже количество ссылок на этот файл у inode будет равняться 0 и данные будут удалены с диска окончательно.

Важно отметить, что hard link можно сделать только для файла, но не для директории!

Кроме того hard link можно создавать только на одной и той же ФС, не на разных!

Т.е. нельзя сделать hard link для файла хранящегося на локальном SSD `/home/aaron/file` на примонтированный бекапный диск `/mnt/Backups/file`.

При создании hard link необходимо иметь права на запись в destination-каталоге. Кроме того все задействованные в работе пользователи должны иметь соответствующие права на доступ к файлу.

```bash
usermod -a -G family aaron
usermod -a -G family jane
chmod 660 /home/aaron/Pictures/family_dog.jpg
```

### Soft links

Создать soft link: `ln -s path_to_target_file path_to_link_file`.

Если в выводе команды `ls -l` не отображается полный путь soft link, то можно воспользоваться командой: `readlink shortcut.jpg`.

Soft link можно создать и для файла и для директории.