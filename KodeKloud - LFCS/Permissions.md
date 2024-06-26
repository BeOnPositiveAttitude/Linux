Изменить группу-владельца файла или директории: `chgrp group_name file/directory_name`.

При чем можно поменять только на группу, в которой состоит владелец файла, иначе получим ошибку `Operation not permitted`. Либо менять с использованием `sudo`.

Посмотреть в каких группах состоит текущий пользователь: `groups`.

Например, мы получили следующий вывод:

```bash
groups
aaron wheel family
```

Это значит, что мы можем изменить группу только на `aaron`, `wheel` или `family`.

Бит `x`, установленный на директории, означает, что мы можем выполнить команду `cd`, т.е. "провалиться" в эту директорию.

### Пример

Существует некий файл со следующими permissions:

`-r--rw---- aaron family file1`

При этом пользователь `aaron` состоит в группе `family`. Сможет ли `aaron` записать в `file1`?

Ответ - нет. Т.к. права вычисляются слева на право, то система определяет - кто пытается записать информацию в файл? Пользователь `aaron`. Кто владелец этого файла? Пользователь `aaron`. У него есть права на запись? Нет. Далее права не вычисляются, т.к. уже есть совпадение для владельца файла. Соответственно записать в файл он не сможет.

Если же в файл попытается записать другой пользователь - `jane`, который при этом состоит в группе `family`, то расчет permissions будет такой.

Кто пытается записать информацию в файл? Пользователь `jane`. Кто владелец этого файла? Пользователь `aaron`. Ок, permissions владельца не применимы в данном случае. Двигаемся дальше к group permissions. Пользователь `jane` состоит в группе `family`? Да, состоит. У группы есть права на запись? Да. Значит в данном случае применимы group permissions и `jane` сможет записать в файл.

`chmod u+rw,g=r,o= file1`, здесь `u+rw` означает добавить права к уже существующим, `g=r` задать в точности права на чтение, `o=` сделать пустые permissions `---`.

Изменить только пользователя владельца, группу не менять: `sudo chown bob /opt/bob/`.

Также существует полезная команда `stat` для просмотра permissions файла.

```bash
aidar@xubuntu-vm:~$ stat Downloads/testperm
  File: Downloads/testperm
  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
Device: fc00h/64512d    Inode: 262258      Links: 1
Access: (0460/-r--rw----)  Uid: ( 1000/   aidar)   Gid: (   24/   cdrom)
Access: 2024-06-10 17:44:07.529518473 +0400
Modify: 2024-06-10 17:44:07.529518473 +0400
Change: 2024-06-10 17:48:34.171918918 +0400
 Birth: 2024-06-10 17:44:07.529518473 +0400
```